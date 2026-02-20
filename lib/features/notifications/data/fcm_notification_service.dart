import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pulse_ops/features/notifications/domain/notification_service.dart';
import '../presentation/notification_router.dart';

class FcmNotificationService implements NotificationService {
  final FirebaseMessaging messaging;

  FcmNotificationService(this.messaging);

  @override
  Future<void> init() async {
    await messaging.requestPermission();

    FirebaseMessaging.onMessage.listen((message) {
      print('Foreground notification: ${message.data}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final id = message.data['incidentId'];
      if (id != null) {
        NotificationRouter.openIncident(id);
      }
    });

    final initial = await messaging.getInitialMessage();
    if (initial != null) {
      final id = initial.data['incidentId'];
      if (id != null) {
        NotificationRouter.openIncident(id);
      }
    }
  }

  @override
  Future<String?> getToken() => messaging.getToken();
}