import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:shop_hub/core/routing/app_routes.dart";
import "package:shop_hub/presentation/pages/index.dart";
import "package:shop_hub/presentation/widgets/app_scaffold.dart";

import "app_navigator_key.dart";
import "app_transitions.dart";

final appRouter = GoRouter(
  debugLogDiagnostics: true,
  navigatorKey: AppNavigatorKey.instance,
  initialLocation: AppRoutes.welcome,
  errorBuilder: (context, state) =>
      const AppScaffold(body: Center(child: Text("ERROR"))),
  routes: [
    GoRoute(
      path: AppRoutes.welcome,
      pageBuilder: (context, state) => AppTransitions.fadeSlide(
        context: context,
        state: state,
        child: const WelcomePage(),
      ),
      // builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: AppRoutes.card,
      pageBuilder: (context, state) => AppTransitions.fadeSlide(
        context: context,
        state: state,
        child: const AppScaffold(body: Center(child: Text("PANIER"))),
      ),
      // builder: (context, state) =>
      //     const AppScaffold(body: Center(child: Text("PANIER"))),
    ),
    // App shell with bottom navigation
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              pageBuilder: (context, state) => AppTransitions.fadeSlide(
                context: context,
                state: state,
                child: const HomePage(),
              ),
              // builder: (context, state) =>
              //     const AppScaffold(body: Center(child: Text("HOME"))),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.products,
              pageBuilder: (context, state) {
                return AppTransitions.fadeSlide(
                  context: context,
                  state: state,
                  child: const AppScaffold(
                    body: Center(child: Text("PRODUITS")),
                  ),
                );
              },
              // builder: (context, state) =>
              //     const AppScaffold(body: Center(child: Text("PRODUIT"))),
              routes: [
                GoRoute(
                  path: ":id",
                  pageBuilder: (context, state) {
                    final id = state.pathParameters["id"] ?? "0";
                    return AppTransitions.fadeSlide(
                      context: context,
                      state: state,
                      child: AppScaffold(
                        body: Center(child: Text("PRODUIT $id")),
                      ),
                    );
                  },
                  // builder: (_, state) {
                  //   final id = state.pathParameters["id"] ?? "0";
                  //   return AppScaffold(
                  //     body: Center(child: Text("PRODUIT $id")),
                  //   );
                  // },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.favourites,
              pageBuilder: (context, state) => AppTransitions.fadeSlide(
                context: context,
                state: state,
                child: const AppScaffold(body: Center(child: Text("FAVORIS"))),
              ),
              // builder: (context, state) =>
              //     const AppScaffold(body: Center(child: Text("FAVORIS"))),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              pageBuilder: (context, state) => AppTransitions.fadeSlide(
                context: context,
                state: state,
                child: const AppScaffold(body: Center(child: Text("PROFIL"))),
              ),
              // builder: (context, state) =>
              //     const AppScaffold(body: Center(child: Text("PROFIL"))),
              //   routes: [
              //     GoRoute(
              //       path: "edit",
              //       builder: (_, state) {
              //         return const EditProfilePage();
              //       },
              //     ),
              //   ],
            ),
          ],
        ),
      ],
    ),
  ],
);
