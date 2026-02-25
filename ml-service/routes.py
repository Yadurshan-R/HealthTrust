"""
API Route Handlers for Insurance Fraud Detection
All FastAPI endpoint logic is defined here, keeping main.py clean.
"""

from fastapi import APIRouter, HTTPException, Depends, status, File, UploadFile, Form
from pydantic import BaseModel, Field, validator
from sqlalchemy.orm import Session
from sqlalchemy import desc
from typing import Optional, List
from datetime import datetime, date, timedelta
import logging
import tempfile
import os
import random
import time
import httpx

from model_loader import get_model, FraudDetectionModel
from database import get_db, User, Claim

logger = logging.getLogger(__name__)

# Create API router
router = APIRouter()


# ==============================
# Pydantic Request/Response Models
# ==============================

class ClaimRequest(BaseModel):
    """Request model for claim prediction"""
    user_id: int = Field(..., description="User ID from database", gt=0)
    amount_billed: float = Field(..., description="Claim amount in USD", gt=0)
    amount_ada: float = Field(..., description="Equivalent amount in ADA at time of submission", gt=0)
    diagnosis: str = Field(..., description="Diagnosis category")

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
    prediction: int
    prediction_label: str
    confidence: float
    ml_status: str
    message: str
    amount_ada: Optional[float] = None


class UserClaimsResponse(BaseModel):
    """Response model for user's claims"""
    user_id: int
    name: str
    email: str
    wallet_address: str
    age: Optional[int] = None
    gender: Optional[str] = None
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


class PayoutRequest(BaseModel):
    """Request model for triggering payout"""
    payout_address: Optional[str] = None


class ProfileUpdateRequest(BaseModel):
    """Request model for updating user profile"""
    name: Optional[str] = Field(None, min_length=2, max_length=100)
    age: Optional[int] = Field(None, ge=1, le=120)
    gender: Optional[str] = None

    @validator('gender')
    def validate_gender(cls, v):
        if v is not None and v not in ('Male', 'Female'):
            raise ValueError('Gender must be Male or Female')
        return v


# ==============================
# ADA Price Cache (CoinMarketCap)
# ==============================
_ada_price_cache = {"price": None, "timestamp": 0}
ADA_PRICE_CACHE_TTL = 60  # seconds

CMC_API_KEY = os.environ.get("CMC_API_KEY", "15030636822d46cfaac0daa137ec0ba2")


async def get_ada_usd_price() -> float:
    """Fetch current ADA/USD price from CoinMarketCap with 60s caching."""
    now = time.time()
    if _ada_price_cache["price"] and (now - _ada_price_cache["timestamp"]) < ADA_PRICE_CACHE_TTL:
        return _ada_price_cache["price"]

    try:
        async with httpx.AsyncClient(timeout=10) as client:
            resp = await client.get(
                "https://pro-api.coinmarketcap.com/v2/cryptocurrency/quotes/latest",
                params={"symbol": "ADA", "convert": "USD"},
                headers={"X-CMC_PRO_API_KEY": CMC_API_KEY},
            )
            resp.raise_for_status()
            data = resp.json()
            price = data["data"]["ADA"][0]["quote"]["USD"]["price"]
            _ada_price_cache["price"] = price
            _ada_price_cache["timestamp"] = now
            logger.info(f"ADA price fetched: ${price:.4f}")
            return price
    except Exception as e:
        logger.error(f"Failed to fetch ADA price: {e}")
        if _ada_price_cache["price"]:
            return _ada_price_cache["price"]  # Return stale cache
        raise HTTPException(status_code=503, detail="Unable to fetch ADA price")


# ==============================
# Endpoints
# ==============================

@router.get("/ada-price")
async def get_ada_price():
    """Get current ADA/USD exchange rate from CoinMarketCap."""
    price = await get_ada_usd_price()
    return {
        "ada_usd": price,
        "timestamp": datetime.utcnow().isoformat(),
    }


@router.get("/", response_model=HealthResponse)
async def health_check(model: FraudDetectionModel = Depends(get_model)):
    """Health check endpoint"""
    return HealthResponse(
        status="healthy",
        model=model.metadata['model_name'],
        accuracy=model.metadata['accuracy'],
        f1_score=model.metadata['f1_score'],
        timestamp=datetime.utcnow().isoformat()
    )


@router.post("/predict", response_model=ClaimResponse, status_code=status.HTTP_201_CREATED)
async def predict_claim(
    claim: ClaimRequest,
    db: Session = Depends(get_db),
    model: FraudDetectionModel = Depends(get_model)
):
    """
    Submit a claim and get ML fraud prediction.
    Updates the claims table with ml_status.
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
            age=user_age,
            gender=user_gender,
            diagnosis=claim.diagnosis
        )

        # Create claim record with confidence score
        new_claim = Claim(
            user_id=claim.user_id,
            amount_billed=claim.amount_billed,
            amount_ada=claim.amount_ada,
            age=user_age,
            gender=user_gender,
            diagnosis=claim.diagnosis,
            ml_status=prediction_result['prediction_label'],
            confidence=prediction_result['confidence'],
            payout_status='rejected' if prediction_result['prediction_label'] == 'fake' else 'pending'
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
        print(f"   Amount Billed:      ${claim.amount_billed:,.2f} USD")
        print(f"   Amount in ADA:      ₳{claim.amount_ada:,.4f} ADA")
        print(f"\n🤖 AI FRAUD DETECTION RESULT:")
        print(f"   Prediction:         {prediction_result['prediction_label'].upper()}")
        print(f"   Confidence Score:   {prediction_result['confidence']:.2%}")
        print(f"   Status:             {new_claim.ml_status}")
        print(f"   Payout Status:      {new_claim.payout_status}")

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
            message=message,
            amount_ada=float(claim.amount_ada) if claim.amount_ada else None
        )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Prediction error: {e}")
        raise HTTPException(status_code=500, detail=f"Prediction failed: {str(e)}")


@router.get("/users/{wallet_address}", response_model=UserClaimsResponse)
async def get_user_by_wallet(
    wallet_address: str,
    db: Session = Depends(get_db)
):
    """
    Get user details and claims by wallet address.
    If wallet is not registered, auto-creates a new user account.
    Anyone with a Cardano wallet can join the app.
    """
    user = db.query(User).filter(User.wallet_address == wallet_address).first()

    # Auto-register new wallets
    if not user:
        short_id = wallet_address[-6:]
        user = User(
            name=f"User_{short_id}",
            email=f"user_{short_id}@healthtrust.app",
            wallet_address=wallet_address,
            age=random.randint(25, 55),
            gender=random.choice(["Male", "Female"]),
            expiry_date=date.today() + timedelta(days=365),
            premium=50.00
        )
        db.add(user)
        db.commit()
        db.refresh(user)
        logger.info(f"✨ New user auto-registered: {user.name} ({wallet_address[:20]}...)")

    claims_data = []
    for claim in user.claims:
        claims_data.append({
            'id': claim.id,
            'amount_billed': float(claim.amount_billed),
            'amount_ada': float(claim.amount_ada) if claim.amount_ada else None,
            'age': claim.age,
            'gender': claim.gender,
            'diagnosis': claim.diagnosis,
            'ml_status': claim.ml_status,
            'confidence': float(claim.confidence) if claim.confidence else None,
            'images': claim.images,
            'image_score': float(claim.image_score) if claim.image_score else None,
            'payout_status': claim.payout_status,
            'tx_hash': claim.tx_hash,
            'block_height': claim.block_height,
            'slot': claim.slot,
            'created_at': claim.created_at.isoformat(),
            'can_claim': (
                claim.ml_status == 'genuine' and
                claim.payout_status == 'pending' and
                claim.images != 'fake'  # Block payout if image verification failed
            )
        })

    return UserClaimsResponse(
        user_id=user.id,
        name=user.name,
        email=user.email,
        wallet_address=user.wallet_address,
        age=user.age,
        gender=user.gender,
        expiry_date=user.expiry_date.isoformat(),
        premium=float(user.premium),
        claims=claims_data
    )


@router.put("/claims/{claim_id}/trigger-payout")
async def trigger_payout(
    claim_id: int,
    request: PayoutRequest = None,
    db: Session = Depends(get_db)
):
    """
    Trigger payout for a genuine claim.
    Sets payout_status to 'trigger' for Go automation service to process.
    """
    claim = db.query(Claim).filter(Claim.id == claim_id).first()
    if not claim:
        raise HTTPException(status_code=404, detail="Claim not found")

    if claim.ml_status != 'genuine':
        raise HTTPException(status_code=400, detail="Cannot trigger payout for non-genuine claim")

    if claim.images == 'fake':
        raise HTTPException(status_code=400, detail="Cannot trigger payout — image verification failed")

    if claim.payout_status != 'pending':
        raise HTTPException(status_code=400, detail=f"Claim already {claim.payout_status}")

    payout_address = request.payout_address if request else None

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


@router.put("/users/{wallet_address}/profile")
async def update_profile(
    wallet_address: str,
    profile: ProfileUpdateRequest,
    db: Session = Depends(get_db)
):
    """Update user profile (name, age, gender) after first wallet connection."""
    user = db.query(User).filter(User.wallet_address == wallet_address).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    if profile.name is not None:
        user.name = profile.name
    if profile.age is not None:
        user.age = profile.age
    if profile.gender is not None:
        user.gender = profile.gender

    db.commit()
    db.refresh(user)

    logger.info(f"Profile updated for {user.name} ({wallet_address[:20]}...)")

    return {
        "message": "Profile updated successfully",
        "user_id": user.id,
        "name": user.name,
        "age": user.age,
        "gender": user.gender
    }


@router.get("/model/info")
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


@router.get("/recent-activity")
async def get_recent_activity(
    limit: int = 10,
    db: Session = Depends(get_db)
):
    """
    Get recent processed claims for public display (before wallet connection).
    Returns all recent claims — both approved (with tx_hash) and rejected.
    No private user data is exposed.
    """
    recent_claims = (
        db.query(Claim)
        .order_by(desc(Claim.created_at))
        .limit(limit)
        .all()
    )

    activities = []
    for claim in recent_claims:
        # Determine overall status: rejected if ML says fake OR image verification failed
        if claim.ml_status == "fake":
            status = "rejected"
        elif claim.images == "fake":
            status = "rejected"
        else:
            status = "approved"

        activities.append({
            "claim_id": claim.id,
            "status": status,
            "amount": float(claim.amount_billed),
            "amount_ada": float(claim.amount_ada) if claim.amount_ada else None,
            "diagnosis": claim.diagnosis,
            "tx_hash": claim.tx_hash,
            "payout_status": claim.payout_status,
            "created_at": claim.created_at.isoformat() if claim.created_at else None,
            "updated_at": claim.updated_at.isoformat() if claim.updated_at else None,
        })

    return {"transactions": activities, "count": len(activities)}


@router.post("/verify-images")
async def verify_images(
    claim_id: int = Form(...),
    prescription_image: UploadFile = File(...),
    receipt_image: UploadFile = File(...),
    db: Session = Depends(get_db)
):
    """
    Verify prescription and receipt images for an existing claim.
    Updates claim with image verification results and combined score.
    """
    try:
        from prescription_verifier import verify_prescription

        claim = db.query(Claim).filter(Claim.id == claim_id).first()
        if not claim:
            raise HTTPException(status_code=404, detail=f"Claim {claim_id} not found")

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

        # Determine final status based on combined score
        final_status = "genuine" if combined_score >= 80 else "fake"

        # Update claim with image verification results
        # IMPORTANT: Only update image fields — never overwrite ml_status!
        # ML result and image result are independent verifications.
        claim.images = image_status
        claim.image_score = image_score

        # If image verification failed, reject the payout
        if image_status == "fake":
            claim.payout_status = "rejected"

        db.commit()
        db.refresh(claim)

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

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Image verification error: {e}")
        raise HTTPException(status_code=500, detail=f"Image verification failed: {str(e)}")
