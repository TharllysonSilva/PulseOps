import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/global_providers.dart';
import '../../domain/entities/incident.dart';
import '../providers/incidents_usecases_providers.dart';
import '../models/incidents_filter.dart';

/// STREAM PRINCIPAL DA LISTA
final incidentsStreamProvider = StreamProvider<List<Incident>>((ref) {
  final getIncidents = ref.watch(getIncidentsUsecaseProvider);
  return getIncidents(); // repo.watchAll()
});

/// FILTRO DE STATUS
final incidentsFilterProvider =
    StateProvider<IncidentsFilter>((ref) => IncidentsFilter.all);

/// LISTA FILTRADA
final filteredIncidentsProvider =
    Provider<AsyncValue<List<Incident>>>((ref) {
  final incidentsAsync = ref.watch(incidentsStreamProvider);
  final filter = ref.watch(incidentsFilterProvider);

  return incidentsAsync.whenData((list) {
    switch (filter) {
      case IncidentsFilter.open:
        return list.where((e) => e.status == 'open').toList();
      case IncidentsFilter.resolved:
        return list.where((e) => e.status == 'resolved').toList();
      case IncidentsFilter.all:
        return list;
    }
  });
});

/// CONTROLLER → apenas AÇÕES
final incidentsControllerProvider =
    AsyncNotifierProvider<IncidentsController, void>(
        IncidentsController.new);

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
        status: 'open',
        updatedAt: DateTime.now(),
      );

      await createIncident(incident);
    });
  }

  Future<void> sync() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(syncFacadeProvider).run();
    });
  }

  Future<void> resolve(Incident incident) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final resolveIncident = ref.read(resolveIncidentUsecaseProvider);
      await resolveIncident(incident);
    });
  }
}