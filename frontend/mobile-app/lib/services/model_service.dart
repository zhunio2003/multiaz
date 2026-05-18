import 'package:mobile_app/core/network/api_client.dart';
import 'package:mobile_app/models/ai_model.dart';

class ModelService {
  final ApiClient _apiClient;

  ModelService(
    this._apiClient
  );

  Future<List<AiModel>> getActiveModels() async {
    final response = await _apiClient.get('/models', queryParameters: {'status': 'ACTIVE'});
    return (response.data as List)
    .map((item) => AiModel.fromJson(item))
    .toList();
  }


}