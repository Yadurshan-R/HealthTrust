"""
Database models and connection for Cardano Insurance dApp
SQLAlchemy ORM models matching the PostgreSQL schema
"""

import os
from datetime import datetime
from decimal import Decimal
from sqlalchemy import create_engine, Column, Integer, String, Numeric, Date, DateTime, ForeignKey, CheckConstraint
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://yadu:Ashokan321@localhost:5432/HealthTrust")

engine = create_engine(DATABASE_URL, echo=False)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()


class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    email = Column(String(255), unique=True, nullable=False, index=True)
    wallet_address = Column(String(255), unique=True, nullable=False, index=True)
    age = Column(Integer, nullable=True)  # Patient age
    gender = Column(String(10), nullable=True)  # Male or Female
    expiry_date = Column(Date, nullable=False)
    premium = Column(Numeric(10, 2), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationship
    claims = relationship("Claim", back_populates="user", cascade="all, delete-orphan")


class Claim(Base):
    __tablename__ = "claims"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    amount_billed = Column(Numeric(10, 2), nullable=False)
    age = Column(Integer, nullable=False)
    gender = Column(String(10), nullable=False)
    diagnosis = Column(String(100), nullable=False)
    ml_status = Column(String(20), default="pending")  # pending, genuine, fake
    confidence = Column(Numeric(5, 4), nullable=True)  # ML confidence score (0.0000-1.0000)
    images = Column(String(20), nullable=True)  # Image verification result: genuine or fake
    image_score = Column(Numeric(5, 2), nullable=True)  # Image verification score (0-100)
    payout_status = Column(String(20), default="pending", index=True)  # pending, trigger, completed
    payout_address = Column(String(255), nullable=True)  # Wallet address for payout (overrides user's address)
    tx_hash = Column(String(255), nullable=True)
    block_height = Column(Integer, nullable=True)  # Blockchain block height
    slot = Column(Integer, nullable=True)  # Blockchain slot number
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Constraints
    __table_args__ = (
        CheckConstraint('age > 0 AND age < 150', name='check_age_range'),
        CheckConstraint("gender IN ('Male', 'Female')", name='check_gender'),
        CheckConstraint("ml_status IN ('genuine', 'fake', 'pending')", name='check_ml_status'),
        CheckConstraint("images IN ('genuine', 'fake') OR images IS NULL", name='check_images_status'),
        CheckConstraint("payout_status IN ('pending', 'trigger', 'completed')", name='check_payout_status'),
    )
    
    # Relationship
    user = relationship("User", back_populates="claims")


class PublicPayout(Base):
    __tablename__ = "public_payouts"
    
    id = Column(Integer, primary_key=True, index=True)
    hashed_user_id = Column(String(64), nullable=False)  # Blake2b-256 hash
    amount = Column(Numeric(10, 2), nullable=False)
    tx_hash = Column(String(255), nullable=False, unique=True, index=True)
    timestamp = Column(DateTime, default=datetime.utcnow)


def get_db():
    """Dependency for FastAPI to get database session"""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def init_db():
    """Initialize database tables"""
    Base.metadata.create_all(bind=engine)
    print("✓ Database tables initialized")


if __name__ == "__main__":
    # Test database connection
    try:
        init_db()
        db = SessionLocal()
        user_count = db.query(User).count()
        claim_count = db.query(Claim).count()
        print(f"✓ Database connected successfully")
        print(f"  - Users: {user_count}")
        print(f"  - Claims: {claim_count}")
        db.close()
    except Exception as e:
        print(f"✗ Database connection failed: {e}")
