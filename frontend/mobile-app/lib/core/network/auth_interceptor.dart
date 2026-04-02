import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor{

  String? token;

  AuthInterceptor( {
    required this.token,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {

    if(token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

}