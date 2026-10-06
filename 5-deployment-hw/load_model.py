import os
import pickle
from pathlib import Path

MODEL_PATH = Path(os.getenv("MODEL_PATH", Path(__file__).with_name("pipeline.bin")))
with MODEL_PATH.open('rb') as model_file:
    dv, model = pickle.load(model_file)

lead = {
    "lead_source": "paid_ads",
    "industry": "technology",
    "employment_status": "employed",
    "location": "north_america",
    "number_of_courses_viewed": 2,
    "annual_income": 79276.0,
    "interaction_count": 4,
    "lead_score": 0.41
}

X = dv.transform([lead])
y_pred = model.predict_proba(X)[0, 1]
print("probability", round(y_pred,3))