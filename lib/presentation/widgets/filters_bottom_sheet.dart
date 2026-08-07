import "package:flutter/material.dart";
import "package:hugeicons/hugeicons.dart";
import "package:shop_hub/core/extensions/build_context_extensions.dart";
import "package:shop_hub/core/theme/app_spacing.dart";
import "package:shop_hub/data/models/index.dart"
    show Category, ProductFilter, ProductSortBy, SortOrder;
import "package:shop_hub/presentation/widgets/index.dart"
    show AppElevatedButton, AppOutlinedButton;

/// Feuille modale de sélection des filtres de produits.
///
/// La sélection provisoire (`_draft`) n'est
/// retournée qu'au clic sur « Appliquer ».
class FiltersBottomSheet extends StatefulWidget {
  const FiltersBottomSheet({
    super.key,
    required this.initialFilter,
    this.availableCategories = const [],
  });

  final ProductFilter initialFilter;
  final List<Category> availableCategories;

  @override
  State<FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<FiltersBottomSheet> {
  String? _selectedCategory;
  late double _minPrice;
  late double _maxPrice;
  late double _minRating;
  late bool _inStockOnly;
  ProductSortBy? _sortBy;
  late SortOrder _sortOrder;

  static const double minPossiblePrice = 0.0;
  static const double maxPossiblePrice = 2000.0;

  @override
  void initState() {
    super.initState();
    final f = widget.initialFilter;
    _selectedCategory = f.category;
    _minPrice = (f.minPrice ?? minPossiblePrice).clamp(
      minPossiblePrice,
      maxPossiblePrice,
    );
    _maxPrice = (f.maxPrice ?? maxPossiblePrice).clamp(
      minPossiblePrice,
      maxPossiblePrice,
    );
    if (_minPrice > _maxPrice) {
      final temp = _minPrice;
      _minPrice = _maxPrice;
      _maxPrice = temp;
    }
    _minRating = (f.minRating ?? 0.0).clamp(0.0, 5.0);
    _inStockOnly = f.inStockOnly ?? false;
    _sortBy = f.sortBy;
    _sortOrder = f.sortOrder;
  }

  void _reset() {
    setState(() {
      _selectedCategory = null;
      _minPrice = minPossiblePrice;
      _maxPrice = maxPossiblePrice;
      _minRating = 0.0;
      _inStockOnly = false;
      _sortBy = null;
      _sortOrder = SortOrder.ascending;
    });
  }

  ProductFilter _buildFilter() {
    final hasCustomPrice =
        _minPrice > minPossiblePrice || _maxPrice < maxPossiblePrice;
    return ProductFilter(
      searchQuery: widget.initialFilter.searchQuery,
      category: _selectedCategory,
      minPrice: hasCustomPrice ? _minPrice : null,
      maxPrice: hasCustomPrice ? _maxPrice : null,
      minRating: _minRating > 0.0 ? _minRating : null,
      inStockOnly: _inStockOnly ? true : null,
      sortBy: _sortBy,
      sortOrder: _sortOrder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    final priceRangeText =
        "${_minPrice.toStringAsFixed(0)} \$ - "
        "${_maxPrice.toStringAsFixed(0)} \$";

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: AppSpacing.roundedTopLg,
          ),
          child: Column(
            children: [
              AppSpacing.gapVSm,
              _Header(onClose: context.pop),
              const Divider(),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  children: [
                    // --- SECTION TRI ---
                    const _SectionTitle(title: "Trier par"),
                    AppSpacing.gapVXs,
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      children: ProductSortBy.values.map((sort) {
                        final isSelected = _sortBy == sort;
                        return ChoiceChip(
                          label: Text(_getSortByLabel(sort)),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _sortBy = selected ? sort : null;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    if (_sortBy != null) ...[
                      AppSpacing.gapVSm,
                      Row(
                        children: [
                          const Text("Ordre : "),
                          AppSpacing.gapHSm,
                          ChoiceChip(
                            avatar: const HugeIcon(
                              icon: HugeIcons.strokeRoundedArrowUp01,
                              size: AppSpacing.iconSm,
                            ),
                            label: const Text("Croissant"),
                            showCheckmark: false,
                            selected: _sortOrder == SortOrder.ascending,
                            onSelected: (selected) {
                              if (selected) {
                                setState(
                                  () => _sortOrder = SortOrder.ascending,
                                );
                              }
                            },
                          ),
                          AppSpacing.gapHSm,
                          ChoiceChip(
                            showCheckmark: false,
                            avatar: const HugeIcon(
                              icon: HugeIcons.strokeRoundedArrowDown01,
                              size: AppSpacing.iconSm,
                            ),
                            label: const Text("Décroissant"),
                            selected: _sortOrder == SortOrder.descending,
                            onSelected: (selected) {
                              if (selected) {
                                setState(
                                  () => _sortOrder = SortOrder.descending,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                    AppSpacing.gapVMd,

                    // --- SECTION CATEGORIES ---
                    if (widget.availableCategories.isNotEmpty) ...[
                      const _SectionTitle(title: "Catégories"),
                      AppSpacing.gapVXs,
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.xs,
                        children: widget.availableCategories.map((cat) {
                          final isSelected =
                              _selectedCategory?.toLowerCase() ==
                              cat.slug.toLowerCase();
                          return FilterChip(
                            label: Text(cat.name),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = selected ? cat.slug : null;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      AppSpacing.gapVMd,
                    ],

                    // --- SECTION TRANCHE DE PRIX ---
                    _SectionTitle(title: "Tranche de prix : $priceRangeText"),
                    RangeSlider(
                      values: RangeValues(_minPrice, _maxPrice),
                      max: maxPossiblePrice,
                      divisions: 40,
                      labels: RangeLabels(
                        "${_minPrice.toStringAsFixed(0)} \$",
                        "${_maxPrice.toStringAsFixed(0)} \$",
                      ),
                      onChanged: (values) {
                        setState(() {
                          _minPrice = values.start;
                          _maxPrice = values.end;
                        });
                      },
                    ),
                    AppSpacing.gapVMd,

                    // --- SECTION NOTE MINIMALE ---
                    _SectionTitle(
                      title:
                          "Note minimale : ${_minRating.toStringAsFixed(1)} / 5.0 ⭐",
                    ),
                    Slider(
                      value: _minRating,
                      max: 5.0,
                      divisions: 10,
                      label: _minRating.toStringAsFixed(1),
                      onChanged: (val) {
                        setState(() {
                          _minRating = val;
                        });
                      },
                    ),
                    AppSpacing.gapVMd,

                    // --- SECTION DISPONIBILITE ---
                    const _SectionTitle(title: "Disponibilité"),
                    AppSpacing.gapVXs,
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("En stock uniquement"),
                      subtitle: const Text(
                        "Afficher uniquement les articles "
                            "disponibles en magasin",
                      ),
                      value: _inStockOnly,
                      onChanged: (val) {
                        setState(() {
                          _inStockOnly = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Row(
                spacing: AppSpacing.md,
                children: [
                  Expanded(
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: AppOutlinedButton(
                        onPressed: _reset,
                        text: "Tout effacer",
                      ),
                    ),
                  ),
                  Expanded(
                    child: AppElevatedButton(
                      onPressed: () {
                        context.pop(_buildFilter());
                      },
                      text: "Appliquer",
                    ),
                  ),
                ],
              ),
              AppSpacing.gapVSm,
            ],
          ),
        );
      },
    );
  }

  String _getSortByLabel(ProductSortBy sortBy) {
    switch (sortBy) {
      case ProductSortBy.title:
        return "Titre";
      case ProductSortBy.price:
        return "Prix";
      case ProductSortBy.rating:
        return "Note";
      case ProductSortBy.category:
        return "Catégorie";
      case ProductSortBy.brand:
        return "Marque";
      case ProductSortBy.discountPercentage:
        return "Remise (%)";
      case ProductSortBy.stock:
        return "Stock";
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          iconSize: AppSpacing.iconXl,
          onPressed: onClose,
          icon: const Icon(Icons.close),
        ),
        Text(
          "Filtres",
          style: context.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: AppSpacing.iconXl),
      ],
    );
  }
}
