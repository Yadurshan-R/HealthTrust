#!/bin/bash

# HealthTrust - Quick Deploy to Railway Script
# This script helps you deploy your project to Railway

echo "🚀 HealthTrust Railway Deployment Helper"
echo "========================================="
echo ""

# Check if git is initialized
if [ ! -d .git ]; then
    echo "📦 Initializing Git repository..."
    git init
    echo "✅ Git initialized"
else
    echo "✅ Git already initialized"
fi

# Check if remote exists
if git remote | grep -q 'origin'; then
    echo "✅ Git remote 'origin' already configured"
    REMOTE_URL=$(git remote get-url origin)
    echo "   Remote URL: $REMOTE_URL"
else
    echo ""
    echo "⚠️  No git remote configured yet!"
    echo ""
    echo "Please follow these steps:"
    echo "1. Go to https://github.com and create a new repository"
    echo "2. Copy the repository URL"
    echo "3. Run this command:"
    echo "   git remote add origin YOUR_REPO_URL"
    echo ""
    read -p "Do you want to add the remote now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "Enter your GitHub repository URL: " REPO_URL
        git remote add origin "$REPO_URL"
        echo "✅ Remote added: $REPO_URL"
    fi
fi

echo ""
echo "📝 Adding files to git..."
git add .

echo ""
read -p "Enter commit message (or press Enter for default): " COMMIT_MSG
if [ -z "$COMMIT_MSG" ]; then
    COMMIT_MSG="Initial commit - HealthTrust project ready for deployment"
fi

echo "💾 Committing changes..."
git commit -m "$COMMIT_MSG"

echo ""
echo "🔍 Checking current branch..."
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "   Current branch: $CURRENT_BRANCH"

if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "🔄 Renaming branch to 'main'..."
    git branch -M main
fi

echo ""
read -p "Ready to push to GitHub? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "⬆️  Pushing to GitHub..."
    if git push -u origin main; then
        echo ""
        echo "✅ Successfully pushed to GitHub!"
        echo ""
        echo "🎉 Next Steps:"
        echo "1. Go to https://railway.app"
        echo "2. Sign up/Login with GitHub"
        echo "3. Click 'New Project' → 'Deploy from GitHub repo'"
        echo "4. Select your repository"
        echo "5. Railway will auto-deploy all services!"
        echo ""
        echo "📖 For detailed instructions, see: RAILWAY_DEPLOYMENT_GUIDE.md"
    else
        echo "❌ Push failed. Please check your git configuration."
        echo "You may need to run: git push -u origin main"
    fi
else
    echo ""
    echo "⏸️  Skipped push. You can push later with:"
    echo "   git push -u origin main"
fi

echo ""
echo "========================================="
echo "✅ Git setup complete!"
echo "========================================="
