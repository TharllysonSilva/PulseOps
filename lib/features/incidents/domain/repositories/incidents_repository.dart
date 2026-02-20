import '../entities/incident.dart';

abstract class IncidentsRepository {
  /// Stream reativo para UI (offline-first)
  Stream<List<Incident>> watchAll();

  Future<Incident?> getById(String id);

  Future<void> create(Incident incident);
  Future<void> update(Incident incident);
  Future<void> delete(String id);

  /// dispara sincronização offline → server
  Future<void> sync();
}