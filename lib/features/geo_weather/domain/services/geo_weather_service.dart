class GeoAddress {
  final String displayName;
  const GeoAddress(this.displayName);
}

class WeatherInfo {
  final double temperature;
  final double windSpeed;

  const WeatherInfo({
    required this.temperature,
    required this.windSpeed,
  });
}

abstract class GeoWeatherService {
  Future<GeoAddress?> getAddress(double lat, double lng);
  Future<WeatherInfo?> getWeather(double lat, double lng);
}