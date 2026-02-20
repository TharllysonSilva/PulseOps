import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pulse_ops/features/notifications/domain/notification_service.dart';
import '../presentation/notification_router.dart';

class FcmNotificationService implements NotificationService {
  final FirebaseMessaging messaging;
  final FlutterLocalNotificationsPlugin local =
      FlutterLocalNotificationsPlugin();

  FcmNotificationService(this.messaging);

  @override
  Future<void> init() async {
    await messaging.requestPermission();

    // 🔔 Inicializar notificações locais
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await local.initialize(settings);

    // 📩 FOREGROUND MESSAGE
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });

    // 📲 APP ABERTO PELA NOTIFICAÇÃO
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final id = message.data['incidentId'];
      if (id != null) NotificationRouter.openIncident(id);
    });

    final initial = await messaging.getInitialMessage();
    if (initial != null) {
      final id = initial.data['incidentId'];
      if (id != null) NotificationRouter.openIncident(id);
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'incidents_channel',
      'Incidents',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await local.show(
      0,
      'Novo incidente 🚨',
      'Toque para abrir',
      details,
      payload: message.data['incidentId'],
    );
  }

  @override
  Future<String?> getToken() => messaging.getToken();
}
