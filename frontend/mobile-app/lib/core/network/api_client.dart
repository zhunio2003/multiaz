import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/core/network/auth_interceptor.dart';
import 'package:mobile_app/services/token_service.dart';

class ApiClient {

  static ApiClient? _instance;
  late final Dio _dio;
  late final AuthInterceptor _authInterceptor;
  final String baseUrl = String.fromEnvironment('API_GATEWAY_URL', defaultValue: 'http://10.0.2.2:8080');

  ApiClient._internal(VoidCallback? onLogout) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
      ),
    );
    _authInterceptor = AuthInterceptor(
      tokenService: TokenService(),
      baseUrl: baseUrl,
      onLogout: onLogout, 
    );

    _dio.interceptors.add(_authInterceptor);
  }
  

  factory ApiClient(VoidCallback? onLogout) {

    // onLogout only used on first initialization
    return _instance ??= ApiClient._internal(onLogout);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  } 

} 