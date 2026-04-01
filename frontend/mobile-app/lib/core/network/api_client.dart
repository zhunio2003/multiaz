import 'package:dio/dio.dart';

class ApiClient {

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: String.fromEnvironment('API_GATEWAY_URL', defaultValue: 'http://10.0.2.2:8080'),
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
      )
    );
  }

  static ApiClient? _instance;
  late final Dio _dio;

  factory ApiClient() {
    
    return _instance ??= ApiClient._internal();
  }

} 