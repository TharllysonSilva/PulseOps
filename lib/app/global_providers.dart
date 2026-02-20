import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pulse_ops/features/incidents/data/datasources/local/outbox_local_ds.dart';
import 'package:pulse_ops/features/incidents/data/datasources/remote/incidents_remote__ds.dart';

import '../core/http/dio_client.dart';
import '../infra/db/app_db.dart';

// INCIDENTS
import '../features/incidents/data/datasources/local/incidents_local_ds.dart';
import '../features/incidents/data/repositories/incidents_repository_impl.dart';
import '../features/incidents/domain/repositories/incidents_repository.dart';

// SYNC
import '../features/sync/data/datasources/local/outbox_local_ds.dart';
import '../features/sync/data/sync_facade.dart';

// GEO WEATHER
import '../features/geo_weather/data/geo_weather_service_impl.dart';
import '../features/geo_weather/domain/services/geo_weather_service.dart';

// NOTIFICATIONS
import '../features/notifications/data/fcm_notification_service.dart';
import '../features/notifications/domain/notification_service.dart';

/// DATABASE
final appDbProvider = Provider<AppDb>((ref) => throw UnimplementedError());

/// HTTP
final dioProvider = Provider<Dio>((ref) => DioClient.build());

/// DATASOURCES
final incidentsLocalDsProvider =
    Provider((ref) => IncidentsLocalDataSource(ref.watch(appDbProvider)));

final incidentsRemoteDsProvider =
    Provider((ref) => IncidentsRemoteDataSource(ref.watch(dioProvider)));

final outboxLocalDsProvider =
    Provider((ref) => OutboxLocalDataSource(ref.watch(appDbProvider)));

/// SYNC FACADE
final syncFacadeProvider = Provider((ref) {
  return SyncFacade(
    outbox: ref.watch(outboxLocalDsProvider),
    remote: ref.watch(incidentsRemoteDsProvider),
  );
});

/// REPOSITORY
final incidentsRepositoryProvider = Provider<IncidentsRepository>((ref) {
  return IncidentsRepositoryImpl(
    local: ref.watch(incidentsLocalDsProvider),
    remote: ref.watch(incidentsRemoteDsProvider),
    outbox: ref.watch(outboxLocalDsProvider),
  );
});

/// GEO WEATHER
final geoWeatherServiceProvider = Provider<GeoWeatherService>((ref) {
  return GeoWeatherServiceImpl(ref.watch(dioProvider));
});

/// FIREBASE
final firebaseMessagingProvider = Provider((_) => FirebaseMessaging.instance);

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return FcmNotificationService(ref.watch(firebaseMessagingProvider));
});
