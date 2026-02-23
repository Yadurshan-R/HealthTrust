"""
FastAPI Application Entry Point
Cardano Insurance dApp - ML Prediction Service + Image Verification

This file handles app creation, middleware, startup events.
All route handlers are in routes.py for cleaner separation.
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import logging

from model_loader import get_model
from database import init_db
from routes import router

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

# Register all route handlers from routes.py
app.include_router(router)


# Initialize database and warm up ML model on startup
@app.on_event("startup")
async def startup_event():
    init_db()
    model = get_model()  # Warm up model
    logger.info(f"✓ ML Service started with {model.metadata['model_name']}")


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000, log_level="info")

