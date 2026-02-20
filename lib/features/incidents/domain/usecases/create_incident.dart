import '../entities/incident.dart';
import '../repositories/incidents_repository.dart';

class CreateIncident {
  final IncidentsRepository repository;

  CreateIncident(this.repository);

  Future<void> call(Incident incident) async {
    if (incident.title.trim().isEmpty) {
      throw Exception('Title cannot be empty');
    }

    await repository.create(incident);
  }
}