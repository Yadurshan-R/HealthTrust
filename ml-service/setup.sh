#!/bin/bash

# Cardano Insurance dApp - ML Service Setup Script
# Sets up Python virtual environment and starts ML service

set -e

echo "=========================================="
echo "ML Service Setup"
echo "=========================================="

cd "$(dirname "$0")"

# Check Python version
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found. Please install Python 3.11+"
    exit 1
fi

PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1-2)
echo "✅ Python version: $PYTHON_VERSION"

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo ""
    echo "Creating virtual environment..."
    python3 -m venv venv
    echo "✅ Virtual environment created"
else
    echo "✅ Virtual environment already exists"
fi

# Activate virtual environment
echo ""
echo "Activating virtual environment..."
source venv/bin/activate

# Install dependencies
echo ""
echo "Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt
echo "✅ Dependencies installed"

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    echo ""
    echo "Creating .env file..."
    cat > .env << 'EOF'
DATABASE_URL=postgresql://yadu:Ashokan321@localhost:5432/HealthTrust
EOF
    echo "✅ .env file created"
fi

# Check if model files exist
if [ ! -d "models" ] || [ ! -f "models/best_model.pkl" ]; then
    echo ""
    echo "⚠️  Model files not found. Exporting model..."
    python export_model.py
    echo "✅ Model exported"
else
    echo "✅ Model files already exist"
fi

echo ""
echo "=========================================="
echo "✅ ML Service Setup Complete!"
echo "=========================================="
echo ""
echo "To start the ML service:"
echo "  source venv/bin/activate"
echo "  uvicorn main:app --reload"
echo ""
echo "Or simply run:"
echo "  ./start-ml-service.sh"
echo ""
