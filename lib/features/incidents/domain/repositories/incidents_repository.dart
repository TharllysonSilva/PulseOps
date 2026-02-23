import '../entities/incident.dart';

abstract class IncidentsRepository {
  Stream<List<Incident>> watchAll();

  Stream<Incident?> watchById(String id);

  Future<void> create(Incident incident);

  Future<void> update(Incident incident);

  Future<void> delete(String id);

  Future<void> sync();
}
