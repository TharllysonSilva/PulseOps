import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/global_providers.dart';
import '../../domain/entities/incident.dart';

final incidentByIdProvider =
    StreamProvider.family<Incident?, String>((ref, id) {
  final repo = ref.watch(incidentsRepositoryProvider);
  return repo.watchById(id);
});