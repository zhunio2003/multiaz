import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/core/network/network_exception.dart';

class AuthInterceptor extends Interceptor{

  String? token;
  final Dio _refreshDio = Dio();
  String? refreshToken;
  final VoidCallback? onLogout;

  AuthInterceptor( {
    required this.token,
    this.refreshToken,
    this.onLogout,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {

    if(token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {

    if (err.response?.statusCode == 401 && refreshToken != null) {
      try{
        final response = await _refreshDio.post(
          '/auth/refresh',
          data: {'refreshToken': refreshToken}
        );
        token = response.data['accessToken'];
        handler.resolve(await _refreshDio.fetch(err.requestOptions));
      } catch (e) {
        onLogout?.call();
        handler.next(err);
      }
    } else {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: NetworkException.fromDioException(err)
        )
      );
    }

  }

}