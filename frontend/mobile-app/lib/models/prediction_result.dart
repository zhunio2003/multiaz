class PredictionResult {
  final String modelId;
  final String predictionId;
  final String modelName;
  final String result;
  final double confidence;
  
  const PredictionResult ({
    required this.modelId,
    required this.predictionId,
    required this.modelName,
    required this.result,
    required this.confidence
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      modelId: json['modelId'],
      predictionId: json['predictionId'],
      modelName: json['modelName'],
      result: json['result']['result'],
      confidence: json['result']['confidence'],
    );
  }
}