import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:pulse_ops/app/global_providers.dart';


import '../controllers/incidents_controller.dart';
import '../../../geo_weather/domain/services/geo_weather_service.dart';

class IncidentDetailsPage extends ConsumerWidget {
  final String incidentId;
  const IncidentDetailsPage({super.key, required this.incidentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incidentAsync = ref.watch(incidentByIdProvider(incidentId));

    return Scaffold(
      appBar: AppBar(title: const Text('Incident Details')),
      body: incidentAsync.when(
        data: (incident) {
          if (incident == null) {
            return const Center(child: Text('Incident not found'));
          }

          final hasLocation = incident.lat != null && incident.lng != null;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(incident.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(incident.description ?? 'No description'),
              const SizedBox(height: 16),

              if (hasLocation) _LocationSection(lat: incident.lat!, lng: incident.lng!),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}

class _LocationSection extends ConsumerWidget {
  final double lat;
  final double lng;

  const _LocationSection({required this.lat, required this.lng});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final geoService = ref.watch(geoWeatherServiceProvider);

    return FutureBuilder(
      future: Future.wait([
        geoService.getAddress(lat, lng),
        geoService.getWeather(lat, lng),
      ]),
      builder: (context, snapshot) {
        final address = snapshot.data?[0] as GeoAddress?;
        final weather = snapshot.data?[1] as WeatherInfo?;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),

            if (address != null) Text(address.displayName),
            if (weather != null) Text('🌤 ${weather.temperature}°C • Wind ${weather.windSpeed} km/h'),

            const SizedBox(height: 16),

            SizedBox(
              height: 250,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(lat, lng),
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.pulse_ops',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(lat, lng),
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.location_pin, size: 40),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}