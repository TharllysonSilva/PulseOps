import 'package:drift/drift.dart';

import '../../../../../infra/db/app_db.dart';
import '../../dtos/incident_dto.dart';

class IncidentsLocalDataSource {
  final AppDb db;
  IncidentsLocalDataSource(this.db);

  Stream<List<IncidentDto>> watchAll() {
    return (db.select(db.incidents)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch()
        .map((rows) => rows.map(IncidentDto.fromRow).toList());
  }

  Future<IncidentDto?> getById(String id) async {
    final row = await (db.select(db.incidents)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();

    return row == null ? null : IncidentDto.fromRow(row);
  }

  Future<void> upsert(IncidentDto dto, {bool dirty = false}) async {
    await db.into(db.incidents)
        .insertOnConflictUpdate(dto.toCompanion(isDirty: dirty));
  }

  Future<void> delete(String id) async {
    await (db.delete(db.incidents)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  Future<List<IncidentDto>> getDirty() async {
    final rows = await (db.select(db.incidents)
          ..where((t) => t.isDirty.equals(true)))
        .get();

    return rows.map(IncidentDto.fromRow).toList();
  }
}