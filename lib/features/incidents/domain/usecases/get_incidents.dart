import '../entities/incident.dart';
import '../repositories/incidents_repository.dart';

class GetIncidents {
  final IncidentsRepository repo;
  GetIncidents(this.repo);

  Stream<List<Incident>> call() => repo.watchAll();
}
