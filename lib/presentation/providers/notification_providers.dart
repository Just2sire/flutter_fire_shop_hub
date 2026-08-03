import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shop_hub/data/services/notification_service.dart";

final flutterLocalNotificationsPluginProvider =
    Provider<FlutterLocalNotificationsPlugin>(
      (ref) => throw UnimplementedError(),
    );

final notificationServiceProvider = Provider<NotificationService>(
  (ref) {
    final plugin = ref.watch(flutterLocalNotificationsPluginProvider);
    return NotificationService(plugin);
  },
);
