#!/usr/bin/env python3
"""
Export the best model from healthcare_fraud_final.ipynb for production use
This script trains the models and exports the best performer with all preprocessing artifacts
"""

import pandas as pd
import numpy as np
import pickle
import warnings
import glob
from pathlib import Path

warnings.filterwarnings('ignore')

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import accuracy_score, f1_score
from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier, VotingClassifier
from sklearn.linear_model import LogisticRegression

print("=" * 70)
print("EXPORTING MODEL FOR CARDANO INSURANCE DAPP")
print("=" * 70)

# Load dataset
csv_files = glob.glob('../*.csv')
if not csv_files:
    raise FileNotFoundError("No CSV file found. Please ensure simulated_healthcare_claims.csv is in parent directory.")

data = pd.read_csv(csv_files[0])
print(f"✓ Loaded: {csv_files[0]} | Shape: {data.shape}")

# Feature Engineering (matching notebook)
data['FraudStatus'] = (data['Fraud Type'] != 'No Fraud').astype(int)
data['Date Admitted'] = pd.to_datetime(data['Date Admitted'], errors='coerce')
data['Date Discharged'] = pd.to_datetime(data['Date Discharged'], errors='coerce')
data['StayDuration'] = (data['Date Discharged'] - data['Date Admitted']).dt.days.fillna(1).clip(lower=0)

# Drop unnecessary columns
cols_to_drop = ['Patient ID', 'Date Admitted', 'Date Discharged', 'Fraud Type']
data = data.drop(columns=[col for col in cols_to_drop if col in data.columns])
print("✓ Feature engineering complete")

# Split data
X = data.drop('FraudStatus', axis=1)
y = data['FraudStatus']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.25, random_state=42, stratify=y)
print(f"✓ Train: {X_train.shape}, Test: {X_test.shape}")

# One-hot encoding
X_train_enc = pd.get_dummies(X_train, drop_first=True)
X_test_enc = pd.get_dummies(X_test, drop_first=True)

# Align columns
all_cols = list(set(X_train_enc.columns).union(set(X_test_enc.columns)))
X_train_enc = X_train_enc.reindex(columns=all_cols, fill_value=0)
X_test_enc = X_test_enc.reindex(columns=all_cols, fill_value=0)
X_train_enc = X_train_enc.fillna(0)
X_test_enc = X_test_enc.fillna(0)
print(f"✓ One-hot encoding complete: {X_train_enc.shape}")

# Feature scaling
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train_enc)
X_test_scaled = scaler.transform(X_test_enc)
print("✓ Scaling complete")

# Test function
def test_model(model, name, scaled=False):
    try:
        X_tr = X_train_scaled if scaled else X_train_enc
        X_te = X_test_scaled if scaled else X_test_enc
        model.fit(X_tr, y_train)
        y_pred = model.predict(X_te)
        acc = accuracy_score(y_test, y_pred)
        f1 = f1_score(y_test, y_pred, zero_division=0)
        return {'name': name, 'acc': acc, 'f1': f1, 'pred': y_pred, 'model': model}
    except:
        return {'name': name, 'acc': 0, 'f1': 0, 'pred': None, 'model': None}

# Train all 7 models
print("\n" + "-" * 50)
print("TRAINING 7 MODELS:")
print("-" * 50)

models = [
    (LogisticRegression(class_weight='balanced', max_iter=1000), "Logistic", False),
    (SVC(class_weight='balanced', probability=True), "SVC", True),
    (KNeighborsClassifier(n_neighbors=30), "KNN", True),
    (DecisionTreeClassifier(class_weight='balanced'), "Decision Tree", False),
    (RandomForestClassifier(n_estimators=100, class_weight='balanced', random_state=42), "Random Forest", False),
    (GradientBoostingClassifier(n_estimators=50, random_state=42), "Gradient Boosting", False),
    (VotingClassifier([
        ('rf', RandomForestClassifier(n_estimators=100, class_weight='balanced', random_state=42)),
        ('gb', GradientBoostingClassifier(n_estimators=100, random_state=42)),
        ('dt', DecisionTreeClassifier(class_weight='balanced', random_state=42))
    ], voting='soft'), "Voting Ensemble", False)
]

results = []
for model, name, scaled in models:
    result = test_model(model, name, scaled)
    print(f"{name:20} | Acc: {result['acc']:.3f} | F1: {result['f1']:.3f}")
    results.append(result)

# Select best model by F1 score
valid_results = [r for r in results if r['f1'] > 0]
best = max(valid_results, key=lambda x: x['f1']) if valid_results else results[0]

print("\n" + "=" * 70)
print("BEST MODEL SELECTED")
print("=" * 70)
print(f"Model: {best['name']}")
print(f"Accuracy: {best['acc']:.4f}")
print(f"F1 Score: {best['f1']:.4f}")
print("=" * 70)

# Export model and artifacts
export_dir = Path(__file__).parent / 'models'
export_dir.mkdir(exist_ok=True)

# Save the best model
with open(export_dir / 'best_model.pkl', 'wb') as f:
    pickle.dump(best['model'], f)
print(f"\n✓ Saved: {export_dir / 'best_model.pkl'}")

# Save scaler
with open(export_dir / 'scaler.pkl', 'wb') as f:
    pickle.dump(scaler, f)
print(f"✓ Saved: {export_dir / 'scaler.pkl'}")

# Save feature names
with open(export_dir / 'feature_names.pkl', 'wb') as f:
    pickle.dump(list(X_train_enc.columns), f)
print(f"✓ Saved: {export_dir / 'feature_names.pkl'}")

# Save metadata
metadata = {
    'model_name': best['name'],
    'accuracy': best['acc'],
    'f1_score': best['f1'],
    'n_features': len(X_train_enc.columns),
    'feature_names': list(X_train_enc.columns),
    'training_date': pd.Timestamp.now().isoformat(),
    'uses_scaling': 'Gradient Boosting' not in best['name']  # Tree models don't need scaling
}

with open(export_dir / 'metadata.pkl', 'wb') as f:
    pickle.dump(metadata, f)
print(f"✓ Saved: {export_dir / 'metadata.pkl'}")

# Save feature mapping for API (important for frontend)
print("\n" + "=" * 70)
print("FEATURES FOR API INTEGRATION:")
print("=" * 70)
print("Expected features after One-Hot Encoding:")
for i, feat in enumerate(X_train_enc.columns[:10], 1):
    print(f"  {i}. {feat}")
print(f"  ... ({len(X_train_enc.columns)} total features)")

print("\n" + "=" * 70)
print("EXPORT COMPLETE! Ready for FastAPI deployment.")
print("=" * 70)
