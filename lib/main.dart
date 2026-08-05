import "package:flutter/material.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_timezone/flutter_timezone.dart";
import "package:go_router/go_router.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:shop_hub/app.dart";
import "package:shop_hub/core/configs/logger.dart";
import "package:shop_hub/core/routing/app_navigator_key.dart";
import "package:shop_hub/data/services/notification_service.dart";
import "package:shop_hub/presentation/providers/index.dart";
import "package:timezone/data/latest_all.dart" as tz;
import "package:timezone/timezone.dart" as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferences doit être initialisé avant runApp
  final prefs = await SharedPreferences.getInstance();

  // Timezone — requis pour zonedSchedule (notifications planifiées)
  tz.initializeTimeZones();
  final timezoneInfo = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
  Log.d("Timezone local: ${timezoneInfo.identifier}");

  // Notifications
  final notificationPlugin = await NotificationService.createAndInit(
    onTap: _onNotificationTap,
  );
  Log.i("NotificationService initialisé");

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        flutterLocalNotificationsPluginProvider.overrideWithValue(
          notificationPlugin,
        ),
      ],
      child: const MainApp(),
    ),
  );
}

// Tap depuis premier plan ou arrière-plan (app vivante)
void _onNotificationTap(NotificationResponse response) {
  final rawPayload = response.payload;
  if (rawPayload == null || rawPayload.isEmpty) return;

  try {
    final payload = NotificationPayload.fromJsonString(rawPayload);
    Log.i("Notification tappée, route: ${payload.route}");
    AppNavigatorKey.instance.currentState?.context.go(payload.route);
  } catch (e, st) {
    Log.e("Échec parsing payload notification", error: e, stackTrace: st);
  }
}
