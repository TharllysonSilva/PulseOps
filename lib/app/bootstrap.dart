import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infra/db/app_db.dart';
import 'providers.dart';

Future<ProviderContainer> bootstrap() async {
  final container = ProviderContainer(
    overrides: [
      appDbProvider.overrideWithValue(AppDb()),
    ],
  );

  return container;
}