import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:pulse_ops/features/geo_weather/data/geo_weather_service_impl.dart';
import 'package:pulse_ops/features/geo_weather/domain/services/geo_weather_service.dart';
import 'package:pulse_ops/features/incidents/data/datasources/local/outbox_local_ds.dart';
import 'package:pulse_ops/features/incidents/data/datasources/remote/incidents_remote__ds.dart';
import 'package:pulse_ops/features/sync/data/sync_facade.dart';
import '../infra/db/app_db.dart';
import '../core/http/dio_client.dart';
import '../features/incidents/data/datasources/local/incidents_local_ds.dart';
import '../features/incidents/data/repositories/incidents_repository_impl.dart';
import '../features/incidents/domain/repositories/incidents_repository.dart';

// DATABASE
final appDbProvider = Provider<AppDb>((ref) {
  throw UnimplementedError();
});

// HTTP
final dioProvider = Provider<Dio>((ref) {
  return DioClient.build();
});

// DATASOURCES
final incidentsLocalDsProvider = Provider((ref) {
  return IncidentsLocalDataSource(ref.watch(appDbProvider));
});

final incidentsRemoteDsProvider = Provider((ref) {
  return IncidentsRemoteDataSource(ref.watch(dioProvider));
});

final outboxLocalDsProvider = Provider((ref) {
  return OutboxLocalDataSource(ref.watch(appDbProvider));
});

// REPOSITORY
final incidentsRepositoryProvider = Provider<IncidentsRepository>((ref) {
  return IncidentsRepositoryImpl(
    local: ref.watch(incidentsLocalDsProvider),
    remote: ref.watch(incidentsRemoteDsProvider),
    outbox: ref.watch(outboxLocalDsProvider),
  );
});

final geoWeatherServiceProvider = Provider<GeoWeatherService>((ref) {
  return GeoWeatherServiceImpl(ref.watch(dioProvider));
});

final syncFacadeProvider = Provider((ref) {
  return SyncFacade(
    outbox: ref.watch(outboxLocalDsProvider),
    remote: ref.watch(incidentsRemoteDsProvider),
  );
});
