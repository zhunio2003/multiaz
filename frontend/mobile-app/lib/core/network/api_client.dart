import 'package:dio/dio.dart';
import 'package:mobile_app/core/network/auth_interceptor.dart';

class ApiClient {

  static ApiClient? _instance;
  late final Dio _dio;
  late final AuthInterceptor _authInterceptor;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: String.fromEnvironment('API_GATEWAY_URL', defaultValue: 'http://10.0.2.2:8080'),
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
      ),
    );
    _authInterceptor = AuthInterceptor(token: null);
    _dio.interceptors.add(_authInterceptor);
  }
  

  factory ApiClient() {
    
    return _instance ??= ApiClient._internal();
  }

  void updateToken(String token) {
    _authInterceptor.token = token;
  }

} 