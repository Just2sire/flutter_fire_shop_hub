import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:shop_hub/core/routing/app_routes.dart";
import "package:shop_hub/presentation/pages/index.dart";
import "package:shop_hub/presentation/widgets/app_scaffold.dart";

final appRouter = GoRouter(
  initialLocation: AppRoutes.welcome,
  errorBuilder: (context, state) =>
      const AppScaffold(body: Center(child: Text("ERROR"))),
  routes: [
    GoRoute(
      path: AppRoutes.welcome,
      builder: (context, state) => const WelcomePage(),
    ),
    // GoRoute(
    //   path: AppRoutes.watchlist,
    //   builder: (context, state) => const WatchlistPage(),
    // ),
    // // App shell with bottom navigation
    // StatefulShellRoute.indexedStack(
    //   builder: (context, state, navigationShell) {
    //     return AppShell(navigationShell: navigationShell);
    //   },
    //   branches: [
    //     StatefulShellBranch(
    //       routes: [
    //         GoRoute(
    //           path: AppRoutes.home,
    //           builder: (context, state) => const HomePage(),
    //         ),
    //       ],
    //     ),
    //     StatefulShellBranch(
    //       routes: [
    //         GoRoute(
    //           path: AppRoutes.movies,
    //           builder: (context, state) => const MoviesPage(),
    //           routes: [
    //             GoRoute(
    //               path: ":id",
    //               builder: (_, state) {
    //                 final id = state.pathParameters["id"] ?? "2";
    //                 return MovieDetailPage(movieId: id);
    //               },
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //     StatefulShellBranch(
    //       routes: [
    //         GoRoute(
    //           path: AppRoutes.favourites,
    //           builder: (context, state) => const FavoritesPage(),
    //         ),
    //       ],
    //     ),
    //     StatefulShellBranch(
    //       routes: [
    //         GoRoute(
    //           path: AppRoutes.profile,
    //           builder: (context, state) => const ProfilePage(),
    //           routes: [
    //             GoRoute(
    //               path: "edit",
    //               builder: (_, state) {
    //                 return const EditProfilePage();
    //               },
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ],
    // ),
  ],
);
