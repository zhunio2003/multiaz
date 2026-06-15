import 'package:mobile_app/core/network/api_client.dart';

class PredictionService {
  final ApiClient _apiClient;
  
  PredictionService(
    this._apiClient,
  );

  // Future<Map<String, dynamic>> predict(String modelId, Map<String, Object>) async {
  //  final response = await _apiClient.post("/predictions")
  //  return 
  //}
}