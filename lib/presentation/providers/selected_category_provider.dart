import "package:flutter_riverpod/legacy.dart";

/// Slug de la catégorie sélectionnée depuis la Home Page.
/// null = aucune catégorie pré-sélectionnée.
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
