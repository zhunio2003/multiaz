import joblib
import os
from schemas.prediction_schema import PredictionResponse

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_PATH = os.path.join(BASE_DIR, "..", "model", "fake_news_model.pkl")

model = joblib.load(MODEL_PATH)

def predict(title: str, text: str):

    content = title  + " " + text
    label = model.predict([content])[0]
    confidence = model.predict_proba([content])[0].max()

    return PredictionResponse(
        result= "REAL" if label == 1 else "FAKE", 
        confidence=confidence
    )
