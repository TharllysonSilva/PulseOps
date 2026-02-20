import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/incident.dart';
import '../providers/incidents_usecases_providers.dart';

// STREAM PARA UI
final incidentsStreamProvider = StreamProvider<List<Incident>>((ref) {
  final getIncidents = ref.watch(getIncidentsUsecaseProvider);
  return getIncidents();
});

// CONTROLLER (ações)
final incidentsControllerProvider =
    AsyncNotifierProvider<IncidentsController, void>(IncidentsController.new);

class IncidentsController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> create({
    required String title,
    String? description,
    double? lat,
    double? lng,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final createIncident = ref.read(createIncidentUsecaseProvider);

      final incident = Incident(
        id: const Uuid().v4(),
        title: title,
        description: description,
        lat: lat,
        lng: lng,
        updatedAt: DateTime.now(),
      );

      await createIncident(incident);
    });
  }

  Future<void> sync() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final sync = ref.read(syncIncidentsUsecaseProvider);
      await sync();
    });
  }
}