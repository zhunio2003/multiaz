import 'package:mobile_app/core/network/api_client.dart';
import 'package:mobile_app/models/prediction_result.dart';

class PredictionService {
  final ApiClient _apiClient;
  
  PredictionService(
    this._apiClient,
  );

  Future<PredictionResult> predict(String modelId, String userId, Map<String, Object> inputData) async {
    final response = await _apiClient.post(
            "/predictions", 
            data: {"modelId": modelId, "inputData": inputData},
            headers: {"X-User-Id": userId},
    );
    return PredictionResult.fromJson(response.data);
  }
}