import 'package:mobile_app/core/network/api_client.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await _apiClient.post('/auth/register', data: {'name': name, 'email': email, 'password': password});
    return response.data;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _apiClient.post('/auth/login', data: {'email': email, 'password': password});
    return response.data;
  }
}