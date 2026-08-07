import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:movify/core/extensions/build_context_extensions.dart";
import "package:movify/core/theme/app_spacing.dart";
import "package:movify/domain/entities/movie_filter.dart";
import "package:movify/domain/entities/movie_rating.dart";
import "package:movify/presentation/widgets/index.dart"
    show AppElevatedButton, AppOutlinedButton;

/// Feuille modale de sélection des filtres de films.
///
/// La sélection provisoire (`_draft`) n'est $
/// retournée qu'au clic sur « Appliquer ».
class FiltersBottomSheet extends StatefulWidget {
  const FiltersBottomSheet({
    super.key,
    required this.initialFilter,
    this.availableGenres = const [],
  });

  final MovieFilter initialFilter;
  final List<String> availableGenres;

  @override
  State<FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<FiltersBottomSheet> {
  late List<String> _selectedGenres;
  late double _minRating;
  late double _maxRating;
  late double _minYear;
  late double _maxYear;
  MovieRating? _selectedRating;
  MovieSortBy? _sortBy;
  late SortOrder _sortOrder;

  static const double minPossibleYear = 1920;
  static const double maxPossibleYear = 2026;

  @override
  void initState() {
    super.initState();
    final f = widget.initialFilter;
    _selectedGenres = List<String>.from(f.genres ?? []);
    if (f.genre != null && !_selectedGenres.contains(f.genre)) {
      _selectedGenres.add(f.genre!);
    }
    _minRating = f.minRating ?? 0.0;
    _maxRating = f.maxRating ?? 10.0;
    _minYear = (f.minYear ?? minPossibleYear).toDouble().clamp(
      minPossibleYear,
      maxPossibleYear,
    );
    _maxYear = (f.maxYear ?? maxPossibleYear).toDouble().clamp(
      minPossibleYear,
      maxPossibleYear,
    );
    _selectedRating = f.rated;
    _sortBy = f.sortBy;
    _sortOrder = f.sortOrder;
  }

  void _reset() {
    setState(() {
      _selectedGenres = [];
      _minRating = 0.0;
      _maxRating = 10.0;
      _minYear = minPossibleYear;
      _maxYear = maxPossibleYear;
      _selectedRating = null;
      _sortBy = null;
      _sortOrder = SortOrder.ascending;
    });
  }

  MovieFilter _buildFilter() {
    return MovieFilter(
      searchQuery: widget.initialFilter.searchQuery,
      genres: _selectedGenres.isEmpty ? null : _selectedGenres,
      minYear: _minYear == minPossibleYear ? null : _minYear.toInt(),
      maxYear: _maxYear == maxPossibleYear ? null : _maxYear.toInt(),
      minRating: _minRating == 0.0 ? null : _minRating,
      maxRating: _maxRating == 10.0 ? null : _maxRating,
      rated: _selectedRating,
      sortBy: _sortBy,
      sortOrder: _sortOrder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    final defaultGenres = widget.availableGenres.isNotEmpty
        ? widget.availableGenres
        : const [
            "Action",
            "Adventure",
            "Animation",
            "Biography",
            "Comedy",
            "Crime",
            "Drama",
            "Family",
            "Fantasy",
            "History",
            "Horror",
            "Music",
            "Mystery",
            "Romance",
            "Sci-Fi",
            "Thriller",
            "Western",
          ];

    final ratingRangeText =
        "${_minRating.toStringAsFixed(1)} - ${_maxRating.toStringAsFixed(1)}";

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
                      children: MovieSortBy.values.map((sort) {
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
                            avatar: const Icon(
                              LucideIcons.arrowUp,
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
                            avatar: const Icon(
                              LucideIcons.arrowDown,
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

                    // --- SECTION GENRES ---
                    const _SectionTitle(title: "Genres"),
                    AppSpacing.gapVXs,
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      children: defaultGenres.map((g) {
                        final isSelected = _selectedGenres.contains(g);
                        return FilterChip(
                          label: Text(g),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedGenres.add(g);
                              } else {
                                _selectedGenres.remove(g);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    AppSpacing.gapVMd,

                    // --- SECTION RATING IMDB ---
                    _SectionTitle(title: "Note IMDb : $ratingRangeText"),
                    RangeSlider(
                      values: RangeValues(_minRating, _maxRating),
                      max: 10.0,
                      divisions: 20,
                      labels: RangeLabels(
                        _minRating.toStringAsFixed(1),
                        _maxRating.toStringAsFixed(1),
                      ),
                      onChanged: (values) {
                        setState(() {
                          _minRating = values.start;
                          _maxRating = values.end;
                        });
                      },
                    ),
                    AppSpacing.gapVMd,

                    // --- SECTION ANNEES ---
                    _SectionTitle(
                      title:
                          "Année de sortie : ${_minYear.toInt()} - "
                          "${_maxYear.toInt()}",
                    ),
                    RangeSlider(
                      values: RangeValues(_minYear, _maxYear),
                      min: minPossibleYear,
                      max: maxPossibleYear,
                      divisions: (maxPossibleYear - minPossibleYear).toInt(),
                      labels: RangeLabels(
                        "${_minYear.toInt()}",
                        "${_maxYear.toInt()}",
                      ),
                      onChanged: (values) {
                        setState(() {
                          _minYear = values.start;
                          _maxYear = values.end;
                        });
                      },
                    ),

                    AppSpacing.gapVMd,

                    // --- SECTION CLASSIFICATION (RATED) ---
                    const _SectionTitle(title: "Classification (Public)"),
                    AppSpacing.gapVXs,
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      children: MovieRating.values.map((rating) {
                        final isSelected = _selectedRating == rating;
                        return ChoiceChip(
                          label: Text("${rating.code} (${rating.label})"),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedRating = selected ? rating : null;
                            });
                          },
                        );
                      }).toList(),
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

  String _getSortByLabel(MovieSortBy sortBy) {
    switch (sortBy) {
      case MovieSortBy.title:
        return "Titre";
      case MovieSortBy.year:
        return "Année";
      case MovieSortBy.imdbRating:
        return "Note IMDb";
      case MovieSortBy.runtime:
        return "Durée";
      case MovieSortBy.boxOffice:
        return "Box Office";
      case MovieSortBy.releasedDate:
        return "Date de sortie";
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
          icon: const Icon(LucideIcons.x),
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
