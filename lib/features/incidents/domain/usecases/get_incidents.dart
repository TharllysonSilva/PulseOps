import '../entities/incident.dart';
import '../repositories/incidents_repository.dart';

class GetIncidents {
  final IncidentsRepository repository;

  GetIncidents(this.repository);

  Stream<List<Incident>> call() {
    return repository.watchAll();
  }
}