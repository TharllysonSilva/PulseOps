import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse_ops/app/providers.dart';
import '../../domain/usecases/create_incident.dart';
import '../../domain/usecases/get_incidents.dart';
import '../../domain/usecases/sync_incidents.dart';

// USECASES PROVIDERS

final createIncidentUsecaseProvider = Provider((ref) {
  return CreateIncident(ref.watch(incidentsRepositoryProvider));
});

final getIncidentsUsecaseProvider = Provider((ref) {
  return GetIncidents(ref.watch(incidentsRepositoryProvider));
});

final syncIncidentsUsecaseProvider = Provider((ref) {
  return SyncIncidents(ref.watch(incidentsRepositoryProvider));
});