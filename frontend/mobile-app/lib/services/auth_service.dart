import 'package:mobile_app/core/network/api_client.dart';
import 'package:mobile_app/services/token_service.dart';

class AuthService {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  AuthService(
    this._apiClient,
    this._tokenService
  );

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await _apiClient.post('/auth/register', data: {'name': name, 'email': email, 'password': password});
    await _tokenService.saveTokens(response.data['accessToken'], response.data['refreshToken']);
    return response.data;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _apiClient.post('/auth/login', data: {'email': email, 'password': password});
    await _tokenService.saveTokens(response.data['accessToken'], response.data['refreshToken']);
    return response.data;
  }
}