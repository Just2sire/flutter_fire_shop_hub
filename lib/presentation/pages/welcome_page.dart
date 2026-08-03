import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:hugeicons/hugeicons.dart";
import "package:shop_hub/core/constants/app_assets.dart";
import "package:shop_hub/core/constants/notification_channels.dart";
import "package:shop_hub/core/extensions/index.dart";
import "package:shop_hub/core/theme/app_colors.dart";
import "package:shop_hub/core/theme/app_spacing.dart";
import "package:shop_hub/presentation/providers/notification_providers.dart";
import "package:shop_hub/presentation/widgets/app_elevated_button.dart";

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: .light,
        statusBarBrightness: .light,
      ),
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage(AppAssets.welcomeOutfit),
              fit: BoxFit.cover,
              colorFilter: .mode(
                AppColors.black.withValues(alpha: 0.4),
                .darken,
              ),
            ),
          ),
          child: Padding(
            padding: AppSpacing.insetLg,
            child: Column(
              crossAxisAlignment: .start,
              mainAxisAlignment: .spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xxl),
                  child: Image.asset(
                    AppAssets.logoDark,
                    width: AppSpacing.tera,
                  ),
                ),
                Column(
                  spacing: AppSpacing.md,
                  mainAxisAlignment: .end,
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      "Bienvenue sur ShopHub",
                      style: textTheme.displaySmall!.copyWith(
                        color: colorScheme.surface,
                        fontWeight: .bold,
                      ),
                    ),
                    Text(
                      "Planifiez votre première notification de bienvenue "
                      "et découvrez nos fonctionnalités !",
                      style: textTheme.bodyMedium!.copyWith(
                        color: colorScheme.surface,
                      ),
                    ),
                    AppSpacing.gapHLg,
                    AppElevatedButton(
                      backgroundColor: colorScheme.surfaceContainer,
                      textColor: colorScheme.onSurface,
                      onPressed: discoverApp,
                      text: "Découvrir",
                      iconAlignment: .end,
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedArrowRight02,
                        color: colorScheme.onSurface,
                      ),
                      margin: .zero,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void discoverApp() {
    ref
        .watch(notificationServiceProvider)
        .show(
          id: NotificationId.welcome,
          title: "Bienvenue sur ShopHub",
          body: "Découvrez les meilleures offres du moment",
        );
    context.goToHome();
  }

  void showWelcomeNotification() {
    ref
        .watch(notificationServiceProvider)
        .show(
          id: NotificationId.welcome,
          title: "Bienvenue sur ShopHub",
          body: "Découvrez les meilleures offres du moment",
        );
  }
}
