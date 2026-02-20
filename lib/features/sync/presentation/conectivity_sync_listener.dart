import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../app/providers.dart';

final connectivitySyncListenerProvider = Provider<void>((ref) {
  final connectivity = Connectivity();

  connectivity.onConnectivityChanged.listen((result) async {
    final hasInternet = result != ConnectivityResult.none;
    if (!hasInternet) return;

    try {
      await ref.read(syncFacadeProvider).run();
    } catch (_) {}
  });
});