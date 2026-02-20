import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infra/db/app_db.dart';
import '../core/http/dio_client.dart';

final appDbProvider = Provider<AppDb>((ref) {
  throw UnimplementedError();
});

final dioProvider = Provider((ref) => DioClient.build());