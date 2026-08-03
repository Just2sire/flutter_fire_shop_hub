// import "package:flutter/material.dart";
// import "package:go_router/go_router.dart";
// import "package:shop_hub/core/routing/app_routes.dart";

// /// Extension pour la navigation GoRouter
// extension NavigationExtensions on BuildContext {
//   /// Navigation vers la page racine
//   void goToRoot() => go(AppRoutes.welcome);

//   /// Navigation vers l'écran de splash
//   void goToWelcome() => go(AppRoutes.welcome);

//   /// Navigation vers l'écran de watchlist
//   void goToWatchlist() => go(AppRoutes.watchlist);
//   void pushToWatchlist() => push(AppRoutes.watchlist);

//   /// Navigation vers la page d'accueil
//   void goToHome() => go(AppRoutes.home);

//   /// Navigation vers la page des films
//   void goToMovies() => go(AppRoutes.movies);

//   /// Navigation vers la page de détail d'un film
//   void goToMovieDetail(String id) => go("${AppRoutes.movies}/$id");

//   /// Navigation vers la page des favoris
//   void goFavourite() => AppRoutes.favourites;

//   /// Navigation vers le profil
//   void goToProfile() => go(AppRoutes.profile);

//   /// Navigation vers la page d'erreur
//   void goToError() => go(AppRoutes.error);

//   /// Navigation avec transition personnalisée
//   void pushWithTransition({
//     required Widget page,
//     required AxisDirection direction,
//   }) {
//     final offset = Offset(
//       direction == AxisDirection.right
//           ? 1
//           : direction == AxisDirection.left
//           ? -1
//           : 0,
//       direction == AxisDirection.down
//           ? 1
//           : direction == AxisDirection.up
//           ? -1
//           : 0,
//     );

//     Navigator.of(this).push(
//       PageRouteBuilder<Widget>(
//         pageBuilder: (context, animation, secondaryAnimation) => page,
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           return SlideTransition(
//             position: animation.drive(
//               Tween<Offset>(
//                 begin: offset,
//                 end: Offset.zero,
//               ).chain(CurveTween(curve: Curves.easeInOut)),
//             ),
//             child: child,
//           );
//         },
//       ),
//     );
//   }

//   // static PageRoute<T> _createRoute<T>(
//   //     Widget page,
//   //     NavigationAnimationType type,
//   //     ) {
//   //   switch (type) {
//   //     case NavigationAnimationType.leftToRight:
//   //       return _createRouteTransition<T>(
//   //         beginOffset: const Offset(-1, 0),
//   //         page: page,
//   //       );
//   //     case NavigationAnimationType.rightToLeft:
//   //       return _createRouteTransition<T>(
//   //         beginOffset: const Offset(1, 0),
//   //         page: page,
//   //       );
//   //     case NavigationAnimationType.topToBottom:
//   //       return _createRouteTransition<T>(
//   //         beginOffset: const Offset(0, -1),
//   //         page: page,
//   //       );
//   //     case NavigationAnimationType.bottomToTop:
//   //       return _createRouteTransition<T>(
//   //         beginOffset: const Offset(0, 1),
//   //         page: page,
//   //       );
//   //   }
//   // }
//   //
//   // static PageRoute<T> _createRouteTransition<T>({
//   //   required Offset beginOffset,
//   //   required Widget page,
//   // }) {
//   //   return PageRouteBuilder(
//   //     pageBuilder: (context, animation, secondaryAnimation) => page,
//   //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//   //       final begin = beginOffset;
//   //       const end = Offset.zero;
//   //       const curve = Curves.easeInOut;
//   //
//   //       final tween = Tween(
//   //         begin: begin,
//   //         end: end,
//   //       ).chain(CurveTween(curve: curve));
//   //       final offsetAnimation = animation.drive(tween);
//   //
//   //       return SlideTransition(position: offsetAnimation, child: child);
//   //     },
//   //   );
//   // }

// }

// enum NavigationAnimationType {
//   leftToRight,
//   rightToLeft,
//   topToBottom,
//   bottomToTop,
// }
