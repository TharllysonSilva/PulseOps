import '../entities/incident.dart';

abstract class IncidentsRepository {
  Stream<List<Incident>> watchAll();

  Stream<Incident?> watchById(String id);

  Future<void> create(Incident incident);

  Future<void> sync();
}