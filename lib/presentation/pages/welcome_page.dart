import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shop_hub/core/constants/notification_channels.dart";
import "package:shop_hub/presentation/providers/notification_providers.dart";
import "package:shop_hub/presentation/widgets/app_scaffold.dart";

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationService = ref.watch(notificationServiceProvider);

    void scheduleWelcomeNotification() {
      notificationService.show(
        id: NotificationId.welcome,
        title: "Bienvenue sur ShopHub",
        body: "Découvrez les meilleures offres du moment",
      );
    }

    return AppScaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Bienvenue sur ShopHub",
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Text(
                "Planifiez votre première notification de bienvenue "
                "et découvrez nos fonctionnalités !",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: scheduleWelcomeNotification,
                child: const Text("Planifier notification"),
              ),
              // PrimaryButton(
              //   text: "Planifier notification",
              //   onPressed: scheduleWelcomeNotification,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
