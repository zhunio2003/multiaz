import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/core/network/auth_interceptor.dart';

class ApiClient {

  static ApiClient? _instance;
  late final Dio _dio;
  late final AuthInterceptor _authInterceptor;

  ApiClient._internal(VoidCallback? onLogout) {
    _dio = Dio(
      BaseOptions(
        baseUrl: const String.fromEnvironment('API_GATEWAY_URL', defaultValue: 'http://10.0.2.2:8080'),
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
      ),
    );
    _authInterceptor = AuthInterceptor(token: null, onLogout: onLogout);
    _dio.interceptors.add(_authInterceptor);
  }
  

  factory ApiClient(VoidCallback? onLogout) {

    // onLogout only used on first initialization
    return _instance ??= ApiClient._internal(onLogout);
  }

  void updateToken(String token) {
    _authInterceptor.token = token;
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  } 

} 