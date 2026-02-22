import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:pulse_ops/app/global_providers.dart';
import 'package:pulse_ops/design/components/app_scaffold.dart';
import 'package:pulse_ops/design/components/status_chip.dart';
import 'package:pulse_ops/design/tokens/colors.dart';
import 'package:pulse_ops/design/tokens/spacing.dart';
import 'package:pulse_ops/design/tokens/typography.dart';
import 'package:pulse_ops/features/geo_weather/domain/services/geo_weather_service.dart';
import '../controllers/incidents_controller.dart';

class IncidentDetailsPage extends ConsumerWidget {
  final String incidentId;
  const IncidentDetailsPage({super.key, required this.incidentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incidentAsync = ref.watch(incidentByIdProvider(incidentId));

    return AppScaffold(
      title: 'Detalhes',
      body: incidentAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (incident) {
          if (incident == null) {
            return const Center(child: Text('Incidente não encontrado'));
          }

          final hasLocation = incident.lat != null && incident.lng != null;

          return ListView(
            children: [
              _Header(incident),
              const SizedBox(height: AppSpacing.lg),
              _InfoCard(incident),
              if (hasLocation)
                _GeoSection(lat: incident.lat!, lng: incident.lng!),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final dynamic incident;
  const _Header(this.incident);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Colors.white, size: 36),
          const SizedBox(height: 12),
          Text(
            incident.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          StatusChip(incident.status),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final dynamic incident;
  const _InfoCard(this.incident);

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Informações',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Row('ID', incident.id),
          _Row('Status', incident.status),
          _Row('Atualizado', incident.updatedAt.toString()),
        ],
      ),
    );
  }
}

class _GeoSection extends ConsumerWidget {
  final double lat;
  final double lng;

  const _GeoSection({required this.lat, required this.lng});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(geoWeatherServiceProvider);

    return FutureBuilder(
      future: Future.wait([
        service.getAddress(lat, lng),
        service.getWeather(lat, lng),
      ]),
      builder: (context, snapshot) {
        final address = snapshot.data?[0] as GeoAddress?;
        final weather = snapshot.data?[1] as WeatherInfo?;

        return Column(
          children: [
            const SizedBox(height: AppSpacing.lg),
            _Card(
              title: 'Clima atual',
              child: weather == null
                  ? const Text('Carregando...')
                  : Text(
                      '${weather.temperature}°C • vento ${weather.windSpeed} km/h'),
            ),
            const SizedBox(height: AppSpacing.lg),
            _Card(
              title: 'Localização',
              child: Column(
                children: [
                  if (address != null) Text(address.displayName),
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
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Widget child;

  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.title),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTypography.caption)),
          Text(value),
        ],
      ),
    );
  }
}
