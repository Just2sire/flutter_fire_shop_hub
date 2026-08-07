import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:hugeicons/hugeicons.dart";
import "package:shop_hub/core/extensions/index.dart";
import "package:shop_hub/core/routing/app_routes.dart";
import "package:shop_hub/core/theme/app_colors.dart";
import "package:shop_hub/core/theme/app_spacing.dart";
import "package:shop_hub/data/models/index.dart" show User;
import "package:shop_hub/presentation/providers/index.dart";
import "package:shop_hub/presentation/widgets/index.dart";

import "../../core/constants/notification_channels.dart";

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final user = userAsync.value;

    return AppScaffold(
      scrollable: true,
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: 100, // Margin for bottom navigation bar
      ),
      body: Builder(
        builder: (_) {
          if (userAsync.isLoading && user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (userAsync.hasError && user == null) {
            return _ProfileErrorState(
              onRetry: () => ref.invalidate(userProvider),
            );
          }

          final currentUser =
              user ??
              User(
                username: "John Doe",
                email: "johndoe@gmail.com",
                phone: "90876534",
              );

          return Column(
            crossAxisAlignment: .start,
            spacing: AppSpacing.md,
            children: [
              const AppTopbar(
                title: "Mon Profil",
                subtitle: "Gérez vos informations & préférences",
                showLeading: false,
                centerTitle: false,
              ),
              AppSpacing.gapVSm,
              _UserHeroCard(user: currentUser),
              AppSpacing.gapVSm,
              const _SectionHeader(title: "Informations Personnelles"),
              _InfoCard(user: currentUser),
              AppSpacing.gapVSm,
              const _SectionHeader(title: "Préférences & Paramètres"),
              const _PreferencesCard(),
              const _SectionHeader(title: "Compte"),
              const _AccountActionsCard(),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileErrorState extends StatelessWidget {
  const _ProfileErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Erreur lors du chargement du profil"),
          AppSpacing.gapVMd,
          AppElevatedButton(onPressed: onRetry, text: "Réessayer"),
        ],
      ),
    );
  }
}

class _UserHeroCard extends StatelessWidget {
  const _UserHeroCard({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final initials = _getInitials(user.username);

    return Container(
      width: double.infinity,
      padding: AppSpacing.insetLg,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppSpacing.roundedXl,
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.25),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: colorScheme.surface,
            child: Text(
              initials,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          AppSpacing.gapHMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username.isNotEmpty ? user.username : "Utilisateur",
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.gapVXs,
                Text(
                  user.email.isNotEmpty ? user.email : "Non renseigné",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimary.withValues(alpha: 0.85),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return "U";
    final parts = name.trim().split(" ");
    if (parts.length >= 2) {
      return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    }
    return name[0].toUpperCase();
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: AppSpacing.roundedLg,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          _InfoTile(
            icon: HugeIcons.strokeRoundedUser,
            label: "Nom d'utilisateur",
            value: user.username.isNotEmpty ? user.username : "Non renseigné",
          ),
          const AppDivider(),
          _InfoTile(
            icon: HugeIcons.strokeRoundedMail01,
            label: "Email",
            value: user.email.isNotEmpty ? user.email : "Non renseigné",
          ),
          const AppDivider(),
          _InfoTile(
            icon: HugeIcons.strokeRoundedSmartPhone01,
            label: "Téléphone",
            value: user.phone.isNotEmpty ? user.phone : "Non renseigné",
          ),
          const AppDivider(),
          Padding(
            padding: AppSpacing.insetSm,
            child: AppOutlinedButton(
              onPressed: () => _showEditProfileDialog(context, user),
              text: "Modifier le profil",
              icon: const HugeIcon(icon: HugeIcons.strokeRoundedEdit02),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, User user) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _EditProfileBottomSheet(user: user),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final List<List<dynamic>> icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: AppSpacing.insetMd,
      child: Row(
        children: [
          HugeIcon(icon: icon, color: theme.colorScheme.primary),
          AppSpacing.gapHMd,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreferencesCard extends ConsumerWidget {
  const _PreferencesCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;
    final currentThemeMode = ref.watch(themeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: AppSpacing.roundedLg,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: HugeIcon(
              icon: isDark
                  ? HugeIcons.strokeRoundedMoon02
                  : HugeIcons.strokeRoundedSun01,
              color: colorScheme.primary,
            ),
            title: const Text("Mode Sombre"),
            subtitle: Text(isDark ? "Activé" : "Désactivé"),
            trailing: Switch(
              value: isDark,
              onChanged: (_) {
                ref.read(themeProvider.notifier).toggleTheme();
              },
            ),
          ),
          const AppDivider(),
          ListTile(
            leading: HugeIcon(
              icon: HugeIcons.strokeRoundedFavourite,
              color: colorScheme.primary,
            ),
            title: const Text("Mes Favoris"),
            trailing: const HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01),
            onTap: () => context.push(AppRoutes.favourites),
          ),
          const AppDivider(),
          ListTile(
            leading: HugeIcon(
              icon: HugeIcons.strokeRoundedShoppingBag01,
              color: colorScheme.primary,
            ),
            title: const Text("Mon Panier"),
            trailing: const HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01),
            onTap: () => context.push(AppRoutes.cart),
          ),
        ],
      ),
    );
  }
}

class _AccountActionsCard extends ConsumerWidget {
  const _AccountActionsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: AppSpacing.roundedLg,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: ListTile(
        leading: const HugeIcon(
          icon: HugeIcons.strokeRoundedDelete02,
          color: AppColors.error,
        ),
        title: Text(
          "Effacer les données utilisateur",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: const Text("Réinitialise le nom, l'email et le téléphone"),
        onTap: () => _confirmResetUser(context, ref),
      ),
    );
  }

  Future<void> _confirmResetUser(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Réinitialiser le profil"),
        content: const Text(
          "Êtes-vous sûr de vouloir effacer les informations "
          "enregistrées pour cet utilisateur ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              ref.read(userProvider.notifier).removeUser();
              ref.read(cartProvider.notifier).clearCart();
              ref.read(favoriteProductProvider.notifier).clearFavorites();
              ref.read(localStorageServiceProvider).resetFirstRun();
              ref.read(notificationServiceProvider).show(
                id: NotificationId.goodBye,
                title: "Au revoir",
                body: "Votre compte a été réinitialisé",
              );
              context
                ..showSnackBar(
                  "Les informations utilisateur et "
                  "le panier ont été réinitialisés.",
                )
                ..goToWelcome();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text("Réinitialiser"),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(userProvider.notifier).removeUser();
      if (context.mounted) {
        context.showSnackBar(
          "Les informations utilisateur ont été réinitialisées.",
        );
      }
    }
  }
}

class _EditProfileBottomSheet extends ConsumerStatefulWidget {
  const _EditProfileBottomSheet({required this.user});

  final User user;

  @override
  ConsumerState<_EditProfileBottomSheet> createState() =>
      _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState
    extends ConsumerState<_EditProfileBottomSheet> {
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          spacing: AppSpacing.md,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Modifier le profil",
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            AppTextFormField(
              controller: _usernameController,
              labelText: "Nom d'utilisateur",
              hintText: "Entrez votre nom",
              prefixIconData: Icons.person_outline,
              isRequired: true,
            ),
            AppTextFormField(
              controller: _emailController,
              labelText: "Email",
              hintText: "exemple@domain.com",
              keyboardType: TextInputType.emailAddress,
              prefixIconData: Icons.email_outlined,
              isRequired: true,
            ),
            AppTextFormField(
              controller: _phoneController,
              labelText: "Téléphone",
              hintText: "90876534",
              keyboardType: TextInputType.phone,
              prefixIconData: Icons.phone_outlined,
            ),
            AppSpacing.gapVXs,
            Row(
              children: [
                Expanded(
                  child: AppOutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    text: "Annuler",
                  ),
                ),
                AppSpacing.gapHMd,
                Expanded(
                  child: AppElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() == true) {
                        final navigator = Navigator.of(context);
                        await ref
                            .read(userProvider.notifier)
                            .updateUser(
                              username: _usernameController.text.trim(),
                              email: _emailController.text.trim(),
                              phone: _phoneController.text.trim(),
                            );
                        if (mounted) navigator.pop();
                      }
                    },
                    text: "Enregistrer",
                  ),
                ),
              ],
            ),
            AppSpacing.gapVSm,
          ],
        ),
      ),
    );
  }
}
