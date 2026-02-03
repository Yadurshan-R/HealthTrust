"""
FastAPI Service for ML-Powered Insurance Fraud Detection
Cardano Insurance dApp - ML Prediction Service + Image Verification
"""

from fastapi import FastAPI, HTTPException, Depends, status, File, UploadFile, Form
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field, validator
from sqlalchemy.orm import Session
from typing import Optional, List
from datetime import datetime
import logging
import tempfile
import os

from model_loader import get_model, FraudDetectionModel
from database import get_db, User, Claim, init_db
from prescription_verifier import verify_prescription

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize FastAPI app
app = FastAPI(
    title="Cardano Insurance ML Service",
    description="ML-powered fraud detection for decentralized insurance claims",
    version="1.0.0"
)

# CORS middleware for frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure properly in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize database on startup
@app.on_event("startup")
async def startup_event():
    init_db()
    model = get_model()  # Warm up model
    logger.info(f"✓ ML Service started with {model.metadata['model_name']}")


# Pydantic models
class ClaimRequest(BaseModel):
    """Request model for claim prediction"""
    user_id: int = Field(..., description="User ID from database", gt=0)
    amount_billed: float = Field(..., description="Claim amount", gt=0)
    diagnosis: str = Field(..., description="Diagnosis category")
    # NOTE: age and gender are auto-fetched from user database
    
    @validator('diagnosis')
    def validate_diagnosis(cls, v):
        valid_diagnoses = [
            'Pregnancy', 'Hypertension', 'Diabetes', 'Pneumonia',
            'Gastroenteritis', 'Cesarean Section', 'Cataract Surgery', 'Other'
        ]
        if v not in valid_diagnoses:
            raise ValueError(f'Diagnosis must be one of: {", ".join(valid_diagnoses)}')
        return v


class ClaimResponse(BaseModel):
    """Response model for claim prediction"""
    claim_id: int
    prediction: int  # 0 = Genuine, 1 = Fraud
    prediction_label: str  # 'genuine' or 'fake'
    confidence: float
    ml_status: str
    message: str


class UserClaimsResponse(BaseModel):
    """Response model for user's claims"""
    user_id: int
    name: str
    email: str
    wallet_address: str
    age: Optional[int] = None  # User age
    gender: Optional[str] = None  # User gender
    expiry_date: str
    premium: float
    claims: List[dict]


class HealthResponse(BaseModel):
    """Health check response"""
    status: str
    model: str
    accuracy: float
    f1_score: float
    timestamp: str


# Endpoints
@app.get("/", response_model=HealthResponse)
async def health_check(model: FraudDetectionModel = Depends(get_model)):
    """Health check endpoint"""
    return HealthResponse(
        status="healthy",
        model=model.metadata['model_name'],
        accuracy=model.metadata['accuracy'],
        f1_score=model.metadata['f1_score'],
        timestamp=datetime.utcnow().isoformat()
    )


@app.post("/predict", response_model=ClaimResponse, status_code=status.HTTP_201_CREATED)
async def predict_claim(
    claim: ClaimRequest,
    db: Session = Depends(get_db),
    model: FraudDetectionModel = Depends(get_model)
):
    """
    Submit a claim and get ML fraud prediction
    Updates the claims table with ml_status
    """
    try:
        # Verify user exists and get user data
        user = db.query(User).filter(User.id == claim.user_id).first()
        if not user:
            raise HTTPException(status_code=404, detail=f"User {claim.user_id} not found")
        
        # Auto-fetch age and gender from user database
        user_age = user.age
        user_gender = user.gender
        
        # Get ML prediction using user's age/gender
        prediction_result = model.predict(
            amount_billed=claim.amount_billed,
            age=user_age,  # From database
            gender=user_gender,  # From database
            diagnosis=claim.diagnosis
        )
        
        # Create claim record with confidence score
        new_claim = Claim(
            user_id=claim.user_id,
            amount_billed=claim.amount_billed,
            age=user_age,
            gender=user_gender,
            diagnosis=claim.diagnosis,
            ml_status=prediction_result['prediction_label'],
            confidence=prediction_result['confidence'],  # Store confidence
            payout_status='pending'
        )
        
        db.add(new_claim)
        db.commit()
        db.refresh(new_claim)
        
        # Prepare response message
        if prediction_result['prediction_label'] == 'fake':
            if prediction_result.get('rejection_reason') == 'low_confidence':
                message = f"Rejected due to low confidence ({prediction_result['confidence']:.1%}). Requires manual review by insurance verifier."
            else:
                message = "Rejected. Our insurance verifier will contact you very soon because we found issues with the claim."
        else:
            message = f"Claim approved by ML verification ({prediction_result['confidence']:.1%} confidence). Payout can be triggered."
        
        # ========================================
        # TERMINAL OUTPUT - Detailed Claim Report
        # ========================================
        print("\n" + "="*80)
        print("🏥 INSURANCE CLAIM SUBMISSION - ML FRAUD DETECTION REPORT")
        print("="*80)
        print(f"\n📋 CLAIM INFORMATION:")
        print(f"   Claim ID:           #{new_claim.id}")
        print(f"   Timestamp:          {new_claim.created_at.strftime('%Y-%m-%d %H:%M:%S')}")
        print(f"\n👤 PATIENT DETAILS:")
        print(f"   Patient Name:       {user.name}")
        print(f"   User ID:            {user.id}")
        print(f"   Email:              {user.email}")
        print(f"   Age:                {user_age} years")
        print(f"   Gender:             {user_gender}")
        print(f"\n🏥 MEDICAL INFORMATION:")
        print(f"   Diagnosis:          {claim.diagnosis}")
        print(f"   Amount Billed:      ₳{claim.amount_billed:,.2f} ADA")
        print(f"\n🤖 AI FRAUD DETECTION RESULT:")
        print(f"   Prediction:         {prediction_result['prediction_label'].upper()}")
        print(f"   Confidence Score:   {prediction_result['confidence']:.2%}")
        print(f"   Status:             {new_claim.ml_status}")
        print(f"   Payout Status:      {new_claim.payout_status}")
        
        # Result indicator
        if prediction_result['prediction_label'] == 'genuine':
            print(f"\n✅ VERDICT: CLAIM APPROVED")
            print(f"   → {message}")
        else:
            print(f"\n❌ VERDICT: CLAIM REJECTED")
            print(f"   → {message}")
        
        print("="*80 + "\n")
        
        logger.info(f"Claim {new_claim.id} created: {prediction_result['prediction_label']} ({prediction_result['confidence']:.2%})")
        
        return ClaimResponse(
            claim_id=new_claim.id,
            prediction=prediction_result['prediction'],
            prediction_label=prediction_result['prediction_label'],
            confidence=prediction_result['confidence'],
            ml_status=new_claim.ml_status,
            message=message
        )
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Prediction error: {e}")
        raise HTTPException(status_code=500, detail=f"Prediction failed: {str(e)}")


@app.get("/users/{wallet_address}", response_model=UserClaimsResponse)
async def get_user_by_wallet(
    wallet_address: str,
    db: Session = Depends(get_db)
):
    """
    Get user details and claims by wallet address
    Used by frontend after wallet connection
    """
    user = db.query(User).filter(User.wallet_address == wallet_address).first()
    if not user:
        raise HTTPException(status_code=404, detail="Wallet address not found")
    
    # Get all claims for this user
    claims_data = []
    for claim in user.claims:
        claims_data.append({
            'id': claim.id,
            'amount_billed': float(claim.amount_billed),
            'age': claim.age,
            'gender': claim.gender,
            'diagnosis': claim.diagnosis,
            'ml_status': claim.ml_status,
            'confidence': float(claim.confidence) if claim.confidence else None,  # ML confidence
            'payout_status': claim.payout_status,
            'tx_hash': claim.tx_hash,
            'block_height': claim.block_height,  # Blockchain block height
            'slot': claim.slot,  # Blockchain slot number
            'created_at': claim.created_at.isoformat(),
            'can_claim': claim.ml_status == 'genuine' and claim.payout_status == 'pending'
        })
    
    return UserClaimsResponse(
        user_id=user.id,
        name=user.name,
        email=user.email,
        wallet_address=user.wallet_address,
        age=user.age,  # Include user age
        gender=user.gender,  # Include user gender
        expiry_date=user.expiry_date.isoformat(),
        premium=float(user.premium),
        claims=claims_data
    )


class PayoutRequest(BaseModel):
    """Request model for triggering payout"""
    payout_address: Optional[str] = None


@app.put("/claims/{claim_id}/trigger-payout")
async def trigger_payout(
    claim_id: int,
    request: PayoutRequest = None,
    db: Session = Depends(get_db)
):
    """
    Trigger payout for a genuine claim
    Sets payout_status to 'trigger' for Go automation service to process
    Optionally accepts payout_address to override the user's wallet address
    """
    claim = db.query(Claim).filter(Claim.id == claim_id).first()
    if not claim:
        raise HTTPException(status_code=404, detail="Claim not found")
    
    if claim.ml_status != 'genuine':
        raise HTTPException(status_code=400, detail="Cannot trigger payout for non-genuine claim")
    
    if claim.payout_status != 'pending':
        raise HTTPException(status_code=400, detail=f"Claim already {claim.payout_status}")
    
    # Get payout address from request
    payout_address = request.payout_address if request else None
    
    # Update status to trigger and store payout address if provided
    claim.payout_status = 'trigger'
    if payout_address:
        claim.payout_address = payout_address
        logger.info(f"Payout triggered for claim {claim_id} to address: {payout_address}")
    else:
        logger.info(f"Payout triggered for claim {claim_id}, will use user's wallet address")
    
    db.commit()
    
    return {
        "message": "Payout triggered successfully",
        "claim_id": claim_id,
        "status": "trigger",
        "payout_address": payout_address,
        "note": "Go automation service will process this claim within 60 seconds"
    }


@app.get("/model/info")
async def get_model_info(model: FraudDetectionModel = Depends(get_model)):
    """Get detailed model information"""
    return {
        "model_name": model.metadata['model_name'],
        "accuracy": model.metadata['accuracy'],
        "f1_score": model.metadata['f1_score'],
        "n_features": model.metadata['n_features'],
        "training_date": model.metadata['training_date'],
        "top_features": model.get_feature_importance(top_n=10)
    }


@app.post("/verify-images")
async def verify_images(
    claim_id: int = Form(...),
    prescription_image: UploadFile = File(...),
    receipt_image: UploadFile = File(...),
    db: Session = Depends(get_db)
):
    """
    Verify prescription and receipt images for an existing claim
    Updates claim with image verification results and combined score
    """
    try:
        # Get the claim
        claim = db.query(Claim).filter(Claim.id == claim_id).first()
        if not claim:
            raise HTTPException(status_code=404, detail=f"Claim {claim_id} not found")
        
        # Get ML confidence as percentage
        ml_confidence_percent = float(claim.confidence) * 100 if claim.confidence else 0
        
        print("\n" + "="*80)
        print(f"📸 IMAGE VERIFICATION FOR CLAIM #{claim_id}")
        print("="*80)
        
        # Save uploaded files temporarily
        with tempfile.NamedTemporaryFile(delete=False, suffix=".jpg") as prescription_temp:
            prescription_temp.write(await prescription_image.read())
            prescription_path = prescription_temp.name
        
        with tempfile.NamedTemporaryFile(delete=False, suffix=".jpg") as receipt_temp:
            receipt_temp.write(await receipt_image.read())
            receipt_path = receipt_temp.name
        
        # Run image verification using GPT-4o Vision API
        is_genuine, match_percentage = verify_prescription(prescription_path, receipt_path)
        
        # Clean up temp files
        os.unlink(prescription_path)
        os.unlink(receipt_path)
        
        # Store results
        image_status = "genuine" if is_genuine else "fake"
        image_score = match_percentage
        
        # Calculate combined score (ML + Image average)
        combined_score = (ml_confidence_percent + image_score) / 2
        
        # Update claim with image verification results
        claim.images = image_status
        claim.image_score = image_score
        db.commit()
        db.refresh(claim)
        
        # Determine final status based on combined score
        final_status = "genuine" if combined_score >= 80 else "fake"
        
        # Terminal output
        print(f"\n📊 IMAGE VERIFICATION RESULTS:")
        print(f"   Prescription-Receipt Match: {image_score:.2f}%")
        print(f"   Image Status:               {image_status.upper()}")
        print(f"\n🎯 COMBINED SCORE CALCULATION:")
        print(f"   ML Confidence:              {ml_confidence_percent:.2f}%")
        print(f"   Image Verification:         {image_score:.2f}%")
        print(f"   Combined Average:           {combined_score:.2f}%")
        print(f"   Formula:                    ({ml_confidence_percent:.2f}% + {image_score:.2f}%) / 2")
        
        if combined_score >= 80:
            print(f"\n✅ FINAL VERDICT: APPROVED")
            print(f"   → Combined score {combined_score:.1f}% meets 80% threshold")
        else:
            print(f"\n❌ FINAL VERDICT: REJECTED")
            print(f"   → Combined score {combined_score:.1f}% below 80% threshold")
        
        print("="*80 + "\n")
        
        logger.info(f"Image verification for claim {claim_id}: Image={image_status} ({image_score:.2f}%), Combined={combined_score:.2f}%")
        
        return {
            "claim_id": claim_id,
            "image_verification": {
                "status": image_status,
                "score": image_score,
                "is_genuine": is_genuine
            },
            "combined_score": combined_score,
            "ml_score": ml_confidence_percent,
            "final_status": final_status,
            "message": f"Combined score: {combined_score:.1f}% ({'✅ APPROVED' if combined_score >= 80 else '❌ REJECTED'})"
        }
        
    except Exception as e:
        logger.error(f"Image verification error: {e}")
        raise HTTPException(status_code=500, detail=f"Image verification failed: {str(e)}")


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000, log_level="info")

