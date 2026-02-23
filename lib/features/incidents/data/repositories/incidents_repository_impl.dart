import 'dart:convert';

import 'package:pulse_ops/features/incidents/data/datasources/local/outbox_local_ds.dart';

import '../../domain/entities/incident.dart';
import '../../domain/repositories/incidents_repository.dart';

import '../datasources/local/incidents_local_ds.dart';
import '../datasources/remote/incidents_remote__ds.dart';

import '../mappers/incident_mapper.dart';

class IncidentsRepositoryImpl implements IncidentsRepository {
  final IncidentsLocalDataSource local;
  final IncidentsRemoteDataSource remote;
  final OutboxLocalDataSource outbox;

  IncidentsRepositoryImpl({
    required this.local,
    required this.remote,
    required this.outbox,
  });

  // =========================
  // WATCH (STREAMS)
  // =========================

  @override
  Stream<List<Incident>> watchAll() {
    return local
        .watchAll()
        .map((dtos) => dtos.map(IncidentMapper.toEntity).toList());
  }

  @override
  Stream<Incident?> watchById(String id) {
    return local
        .watchById(id)
        .map((dto) => dto == null ? null : IncidentMapper.toEntity(dto));
  }

  // =========================
  // COMMANDS (WRITE)
  // =========================

  @override
  Future<void> create(Incident incident) async {
    final dto = IncidentMapper.toDto(incident);
    await local.upsert(dto, dirty: true);

    await outbox.enqueue(
      entityType: 'incident',
      operation: 'create',
      payload: jsonEncode(dto.toJson()),
    );
  }

  @override
  Future<void> update(Incident incident) async {
    final dto = IncidentMapper.toDto(incident);
    await local.upsert(dto, dirty: true);

    await outbox.enqueue(
      entityType: 'incident',
      operation: 'update',
      payload: jsonEncode(dto.toJson()),
    );
  }

  Future<void> delete(String id) async {
    await local.delete(id);

    await outbox.enqueue(
      entityType: 'incident',
      operation: 'delete',
      payload: jsonEncode({'id': id}),
    );
  }

  // =========================
  // SYNC
  // =========================

  @override
  Future<void> sync() async {
    final dirtyItems = await local.getDirty();

    for (final dto in dirtyItems) {
      await remote.update(dto.toJson());
      await local.upsert(dto, dirty: false);
    }

    final latest = await remote.pullLatest();
    for (final dto in latest) {
      await local.upsert(dto, dirty: false);
    }
  }
}
