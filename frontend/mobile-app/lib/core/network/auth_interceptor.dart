import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor{

  String? token;
  final Dio _refreshDio = Dio();
  String? refreshToken;

  AuthInterceptor( {
    required this.token,
    this.refreshToken,
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
        handler.next(err);
      }
    } else {
      handler.next(err);
    }

  }

}