import 'package:dio/dio.dart';

class NetworkException implements Exception {

  final String message;

  NetworkException(this.message);

  factory NetworkException.fromDioException(DioException e) {
    switch(e.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkException('Unable to connect to the server');
      case DioExceptionType.receiveTimeout:
        return NetworkException('The server took too long to response');
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection');
      case DioExceptionType.badResponse:
        return NetworkException('Server error: ${e.response?.statusCode}');
      default:
        return NetworkException('An unexpected error occurred');
    }
  }
    

}