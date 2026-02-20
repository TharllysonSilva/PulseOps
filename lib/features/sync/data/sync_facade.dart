import 'dart:convert';
import 'dart:math';

import 'package:pulse_ops/features/incidents/data/datasources/local/outbox_local_ds.dart';
import 'package:pulse_ops/features/incidents/data/datasources/remote/incidents_remote__ds.dart';

class SyncFacade {
  final OutboxLocalDataSource outbox;
  final IncidentsRemoteDataSource remote;

  SyncFacade({
    required this.outbox,
    required this.remote,
  });

  Future<void> run() async {
    await _pushOutbox();
    await _pullLatest();
  }

  // PUSH OUTBOX COM RETRY EXPONENCIAL
  Future<void> _pushOutbox() async {
    final pending = await outbox.getPending();

    for (final item in pending) {
      try {
        final payload = jsonDecode(item.payload);
        await _retry(
            () => remote.applyOutboxOperation(item.operation, payload));

        await outbox.markSent(item.localId);
      } catch (e) {
        await outbox.markFailed(
          localId: item.localId,
          error: e.toString(),
          retryCount: item.retryCount + 1,
        );
      }
    }
  }

  // PULL DO SERVIDOR
  Future<void> _pullLatest() async {
    await remote.pullLatest();
  }

  // RETRY EXPONENCIAL
  Future<void> _retry(Future<void> Function() task) async {
    const maxAttempts = 3;

    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        await task();
        return;
      } catch (e) {
        if (attempt == maxAttempts - 1) rethrow;

        final delay = pow(2, attempt).toInt();
        await Future.delayed(Duration(seconds: delay));
      }
    }
  }
}
