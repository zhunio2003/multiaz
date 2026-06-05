from pydantic import BaseModel

class PredictionRequest(BaseModel):
    title: str
    text: str

class PredictionResponse(BaseModel):
    result: str
    confidence: float