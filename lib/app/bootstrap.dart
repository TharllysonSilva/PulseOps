import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import '../infra/db/app_db.dart';
import 'global_providers.dart';

Future<ProviderContainer> bootstrap() async {
  await Firebase.initializeApp();

  final container = ProviderContainer(
    overrides: [
      appDbProvider.overrideWithValue(AppDb()),
    ],
  );

  await container.read(notificationServiceProvider).init();
  final token = await container.read(notificationServiceProvider).getToken();
  print("FCM TOKEN: $token");

  return container;
}