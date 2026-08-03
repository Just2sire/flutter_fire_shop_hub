import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:shop_hub/core/routing/router.dart";

final appRouterProvider = Provider<GoRouter>((ref) => appRouter);
