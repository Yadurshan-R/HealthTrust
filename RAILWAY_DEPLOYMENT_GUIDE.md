# 🚀 HealthTrust Railway Deployment Guide

## ✅ What's Configured

I've set up your entire HealthTrust project for Railway deployment with:
- ✅ Frontend (Vue.js)
- ✅ ML Service (Python FastAPI)
- ✅ Blockchain Service (Node.js)
- ✅ Automation Service (Go)
- ✅ PostgreSQL Database (Railway provides this)

## 🎯 Auto-Deployment Feature

**YES!** Once deployed, Railway will **automatically redeploy** your app whenever you:
1. Make changes to your code
2. Commit to GitHub
3. Push to your repository

It's completely automatic - no manual redeployment needed! 🎉

---

## 📋 Deployment Steps

### Step 1: Push to GitHub

```bash
cd /home/yadu/Development/My_FYP/model_1

# Initialize git (if not already done)
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit - HealthTrust project"

# Create a new repository on GitHub, then:
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
git branch -M main
git push -u origin main
```

### Step 2: Sign Up for Railway

1. Go to https://railway.app
2. Click **"Start a New Project"**
3. Sign up with GitHub (recommended for auto-deployment)
4. You get **$5 free credit per month** (usually enough for testing)

### Step 3: Deploy Your Project

1. Click **"New Project"**
2. Select **"Deploy from GitHub repo"**
3. Choose your repository
4. Railway will detect all services automatically!

### Step 4: Add PostgreSQL Database

1. In your Railway project, click **"+ New"**
2. Select **"Database" → "PostgreSQL"**
3. Railway will create a database and provide connection URL

### Step 5: Configure Environment Variables

For **each service**, add these environment variables in Railway dashboard:

#### ML Service
```
DATABASE_URL=${{Postgres.DATABASE_URL}}
OPENAI_API_KEY=your_openai_key_here
PORT=8000
```

#### Blockchain Service
```
DATABASE_URL=${{Postgres.DATABASE_URL}}
BLOCKFROST_API_KEY=your_blockfrost_key
BLOCKFROST_NETWORK=preprod
TREASURY_SEED_PHRASE=your_treasury_seed_phrase
PORT=3001
```

#### Automation Service
```
DATABASE_URL=${{Postgres.DATABASE_URL}}
BLOCKFROST_API_KEY=your_blockfrost_key
BLOCKFROST_NETWORK=preprod
PORT=8080
```

#### Frontend
```
VITE_API_URL=${{blockchain-service.RAILWAY_PUBLIC_DOMAIN}}
VITE_ML_API_URL=${{ml-service.RAILWAY_PUBLIC_DOMAIN}}
```

### Step 6: Deploy!

Railway will automatically:
- ✅ Build all services
- ✅ Set up the database
- ✅ Connect everything
- ✅ Give you public URLs

---

## 🔄 Making Changes (Auto-Deployment)

After initial deployment, to update your app:

```bash
# Make your changes in the code
# Then:
git add .
git commit -m "Updated feature X"
git push
```

**That's it!** Railway will automatically:
1. Detect the push
2. Rebuild your services
3. Deploy the changes
4. Your app will be updated in ~2-5 minutes

---

## 🌐 Access Your Deployed App

After deployment, Railway will give you URLs like:
- Frontend: `https://your-app.railway.app`
- ML API: `https://ml-service.railway.app`
- Blockchain API: `https://blockchain-service.railway.app`

---

## 💰 Free Tier Limits

Railway free tier includes:
- $5 credit per month (renews monthly)
- Usually covers:
  - Small apps with moderate traffic
  - Development/testing environments
  - Personal projects

**Note:** For production with heavy traffic, you may need to upgrade.

---

## 🐛 Troubleshooting

### If a service fails to deploy:

1. Check the logs in Railway dashboard
2. Verify environment variables are set correctly
3. Ensure all dependencies are listed in:
   - `requirements.txt` (Python)
   - `package.json` (Node.js)
   - `go.mod` (Go)

### Database connection issues:

- Make sure `DATABASE_URL` variable references: `${{Postgres.DATABASE_URL}}`
- Run database migrations if needed

---

## 📚 Files Created

I've created these Railway configuration files:
- `/railway.json` - Main project config
- `/client/railway.json` + `Procfile` - Frontend config
- `/ml-service/railway.json` + `Procfile` - ML service config
- `/server/blockchain-service/railway.json` + `Procfile` - Blockchain config
- `/automation-service/railway.json` + `Procfile` - Automation config

---

## 🎉 Next Steps

1. **Push your code to GitHub** (Step 1 above)
2. **Sign up for Railway** (Step 2)
3. **Deploy!** (Step 3-6)
4. **Share your live URL!** 🚀

Your entire project will be online and auto-deploying on every code change!
