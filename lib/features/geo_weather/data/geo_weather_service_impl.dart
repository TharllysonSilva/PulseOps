import 'package:dio/dio.dart';
import '../domain/services/geo_weather_service.dart';
import 'nominatim_geo_ds.dart';
import 'openmeteo_weather_ds.dart';

class GeoWeatherServiceImpl implements GeoWeatherService {
  final NominatimGeoDataSource geoDs;
  final OpenMeteoDataSource weatherDs;

  GeoWeatherServiceImpl(Dio dio)
      : geoDs = NominatimGeoDataSource(dio),
        weatherDs = OpenMeteoDataSource(dio);

  @override
  Future<GeoAddress?> getAddress(double lat, double lng) async {
    final name = await geoDs.reverseGeocode(lat, lng);
    if (name == null) return null;
    return GeoAddress(name);
  }

  @override
  Future<WeatherInfo?> getWeather(double lat, double lng) async {
    final data = await weatherDs.getWeather(lat, lng);
    return WeatherInfo(
      temperature: (data['temperature'] as num).toDouble(),
      windSpeed: (data['windspeed'] as num).toDouble(),
    );
  }
}