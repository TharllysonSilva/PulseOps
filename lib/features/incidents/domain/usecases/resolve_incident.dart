import '../../domain/entities/incident.dart';
import '../repositories/incidents_repository.dart';

class ResolveIncident {
  final IncidentsRepository repository;
  ResolveIncident(this.repository);

  Future<void> call(Incident incident) async {
    final updated = incident.copyWith(
      status: 'resolved',
      updatedAt: DateTime.now(),
    );

    await repository.update(updated);
  }
}