import 'dart:convert';
import 'package:pulse_ops/features/incidents/data/datasources/local/outbox_local_ds.dart';
import 'package:pulse_ops/features/incidents/data/datasources/remote/incidents_remote__ds.dart';

import '../../domain/entities/incident.dart';
import '../../domain/repositories/incidents_repository.dart';
import '../datasources/local/incidents_local_ds.dart';
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

  @override
  Stream<List<Incident>> watchAll() {
    return local
        .watchAll()
        .map((dtos) => dtos.map(IncidentMapper.toEntity).toList());
  }

  @override
  Future<Incident?> getById(String id) async {
    final dto = await local.getById(id);
    return dto == null ? null : IncidentMapper.toEntity(dto);
  }

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

  @override
  Future<void> delete(String id) async {
    await local.delete(id);

    await outbox.enqueue(
      entityType: 'incident',
      operation: 'delete',
      payload: jsonEncode({'id': id}),
    );
  }

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
