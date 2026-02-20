import 'package:drift/drift.dart';
import '../../../../../infra/db/app_db.dart';

class OutboxLocalDataSource {
  final AppDb db;

  OutboxLocalDataSource(this.db);

  Future<void> enqueue({
    required String entityType,
    required String operation,
    required String payload,
  }) async {
    await db.into(db.outbox).insert(
          OutboxCompanion.insert(
            entityType: entityType,
            operation: operation,
            payload: payload,
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<List<OutboxData>> getPending({int limit = 50}) async {
    return (db.select(db.outbox)
          ..where((t) => t.status.equals('pending'))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
          ..limit(limit))
        .get();
  }

  Future<void> markSent(int localId) async {
    await (db.update(db.outbox)..where((t) => t.localId.equals(localId)))
        .write(const OutboxCompanion(status: Value('sent')));
  }

  Future<void> markFailed({
    required int localId,
    required String error,
    required int retryCount,
  }) async {
    await (db.update(db.outbox)..where((t) => t.localId.equals(localId))).write(
      OutboxCompanion(
        status: const Value('failed'),
        lastError: Value(error),
        retryCount: Value(retryCount),
      ),
    );
  }
}