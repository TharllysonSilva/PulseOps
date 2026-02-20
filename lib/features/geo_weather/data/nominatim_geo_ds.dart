import 'package:dio/dio.dart';

class NominatimGeoDataSource {
  final Dio dio;
  NominatimGeoDataSource(this.dio);

  Future<String?> reverseGeocode(double lat, double lng) async {
    final response = await dio.get(
      'https://nominatim.openstreetmap.org/reverse',
      queryParameters: {
        'lat': lat,
        'lon': lng,
        'format': 'json',
      },
      options: Options(headers: {
        'User-Agent': 'pulseops-app',
      }),
    );

    return response.data['display_name'];
  }
}