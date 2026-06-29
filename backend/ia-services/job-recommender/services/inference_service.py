import joblib
import os
from schemas.prediction_schema import PredictionResponse

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_PATH = os.path.join(BASE_DIR, "..", "model", "job_recommender.pkl")

model = joblib.load(MODEL_PATH)

def predict(title: str, text: str):
    return PredictionResponse()