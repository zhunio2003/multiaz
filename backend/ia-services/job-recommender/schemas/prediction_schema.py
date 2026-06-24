from pydantic import BaseModel

class PredictionRequest(BaseModel):
    description: str

class PredictionResponse(BaseModel):
    result: str
    confidence: float

