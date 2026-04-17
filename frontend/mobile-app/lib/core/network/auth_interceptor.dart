import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/core/network/network_exception.dart';
import 'package:mobile_app/services/token_service.dart';

class AuthInterceptor extends Interceptor{

  late Dio _refreshDio = Dio();
  final TokenService _tokenService;
  final VoidCallback? onLogout;

  AuthInterceptor( {
    required TokenService tokenService,
    this.onLogout,
    required String baseUrl,
  }) : _tokenService = tokenService {
    _refreshDio = Dio(BaseOptions(baseUrl: baseUrl));
  }

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {

    String? accessToken = await _tokenService.getAccessToken();

    if(accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {

    String? refreshToken = await _tokenService.getRefreshToken();

    if (err.response?.statusCode == 401 && refreshToken != null) {
      try{
        final response = await _refreshDio.post(
          '/auth/refresh',
          data: {'refreshToken': refreshToken}
        );

        await _tokenService.saveTokens(
          response.data['accessToken'], 
          response.data['refreshToken']
        );

        err.requestOptions.headers['Authorization'] = 'Bearer ${response.data['accessToken']}';
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