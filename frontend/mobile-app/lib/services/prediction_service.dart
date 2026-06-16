import 'package:mobile_app/core/network/api_client.dart';

class PredictionService {
  final ApiClient _apiClient;
  
  PredictionService(
    this._apiClient,
  );

  Future<Map<String, dynamic>> predict(String modelId, Map<String, Object> inputData) async {
    final response = await _apiClient.post("/predictions", data: {"modelId": modelId, "inputData": inputData});
    return response.data;
  }
}