import 'package:dio/dio.dart';
import 'dio_interceptors.dart';

class DioClient {
  static Dio build() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        contentType: 'application/json',
      ),
    );

    dio.interceptors.add(LoggingInterceptor());
    return dio;
  }
}