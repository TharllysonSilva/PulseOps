import 'package:go_router/go_router.dart';

class NotificationRouter {
  static GoRouter? router;

  static void setRouter(GoRouter r) => router = r;

  static void openIncident(String id) {
    router?.go('/incidents/$id');
  }
}