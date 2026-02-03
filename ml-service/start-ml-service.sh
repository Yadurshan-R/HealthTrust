#!/bin/bash

# Start ML Service (FastAPI)
# Make sure to run setup.sh first!

cd "$(dirname "$0")"

if [ ! -d "venv" ]; then
    echo "❌ Virtual environment not found. Run ./setup.sh first!"
    exit 1
fi

echo "Starting ML Service..."
echo "API will be available at: http://localhost:8000"
echo "API Docs: http://localhost:8000/docs"
echo ""

source venv/bin/activate
uvicorn main:app --reload --host 0.0.0.0 --port 8000
