from fastapi import FastAPI
from schemas.prediction_schema import PredictionRequest
from services import inference_service

app = FastAPI()

@app.get("/health")
def health():
    return {"status": "UP"}

@app.post("/predict")
def predict(request: PredictionRequest):
    return inference_service.predict(request.title, request.text)
