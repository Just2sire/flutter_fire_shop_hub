import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod/legacy.dart";
import "package:hugeicons/hugeicons.dart";
import "package:shop_hub/core/routing/app_routes.dart";

final appPageProvider = StateProvider<int>((ref) => 0);

final appNavItemsProvider = Provider(
  (ref) => <_NavItemData>[
    (
      index: 0,
      icon: HugeIcons.strokeRoundedHome04,
      label: "Accueil",
      route: AppRoutes.home,
    ),
    (
      index: 1,
      icon: HugeIcons.strokeRoundedShirt01,
      // icon: HugeIcons.strokeRoundedHoodie,
      label: "Produits",
      route: AppRoutes.products,
    ),
    (
      index: 2,
      icon: HugeIcons.strokeRoundedFavourite,
      label: "Favoris",
      route: AppRoutes.favourites,
    ),
    (
      index: 3,
      icon: HugeIcons.strokeRoundedUser02,
      label: "Profile",
      route: AppRoutes.profile,
    ),
  ],
);

typedef _NavItemData = ({
  int index,
  List<List<dynamic>> icon,
  String label,
  String route,
});
