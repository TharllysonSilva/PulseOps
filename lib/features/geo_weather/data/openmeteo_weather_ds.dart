import 'package:dio/dio.dart';

class OpenMeteoDataSource {
  final Dio dio;
  OpenMeteoDataSource(this.dio);

  Future<Map<String, dynamic>> getWeather(double lat, double lng) async {
    final response = await dio.get(
      'https://api.open-meteo.com/v1/forecast',
      queryParameters: {
        'latitude': lat,
        'longitude': lng,
        'current_weather': true,
      },
    );

    return response.data['current_weather'];
  }
}