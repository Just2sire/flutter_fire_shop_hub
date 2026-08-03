class NotificationChannel {
  NotificationChannel._();

  static const String generalId = "shop_hub_general";
  static const String remindersId = "shop_hub_reminders";
  static const String alertsId = "shop_hub_alerts";

  static const String generalName = "Notifications générales";
  static const String remindersName = "Rappels";
  static const String alertsName = "Alertes importantes";

  static const String generalDescription =
      "Informations générales et mises à jour";
  static const String remindersDescription =
      "Rappels personnalisés et planifiés";
  static const String alertsDescription =
      "Alertes critiques nécessitant une attention immédiate";
}

class NotificationId {
  NotificationId._();

  static const int welcome = 1;
  static const int accountUpdate = 2;

  // Plage 100–9999 réservée aux rappels dynamiques (entityId-based)
  static int forReminder(int entityId) => 100 + (entityId % 9900);
}
