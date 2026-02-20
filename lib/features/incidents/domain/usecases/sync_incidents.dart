import '../repositories/incidents_repository.dart';

class SyncIncidents {
  final IncidentsRepository repository;

  SyncIncidents(this.repository);

  Future<void> call() => repository.sync();
}