import "dart:convert";

import "package:flutter/foundation.dart";
import "package:shop_hub/data/models/product.dart";

/// Sorting fields supported for product lists based on
/// DummyJSON API & local dataset.
enum ProductSortBy {
  title("title"),
  price("price"),
  rating("rating"),
  category("category"),
  brand("brand"),
  discountPercentage("discountPercentage"),
  stock("stock");

  const ProductSortBy(this.value);

  final String value;
}

/// Sorting order direction.
enum SortOrder {
  ascending("asc"),
  descending("desc");

  const SortOrder(this.value);

  final String value;
}

/// Filter criteria for querying or filtering products.
/// Compatible with DummyJSON API parameters and local datasets.
class ProductFilter {
  const ProductFilter({
    this.searchQuery,
    this.category,
    this.categories,
    this.brand,
    this.brands,
    this.tags,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.maxRating,
    this.availabilityStatus,
    this.inStockOnly,
    this.sortBy,
    this.sortOrder = SortOrder.ascending,
  });

  factory ProductFilter.fromMap(Map<String, dynamic> map) {
    ProductSortBy? parseSortBy(Object? val) {
      if (val == null) return null;
      return ProductSortBy.values.firstWhere(
        (e) => e.value == val.toString() || e.name == val.toString(),
        orElse: () => ProductSortBy.title,
      );
    }

    SortOrder parseSortOrder(Object? val) {
      if (val == null) return SortOrder.ascending;
      return SortOrder.values.firstWhere(
        (e) => e.value == val.toString() || e.name == val.toString(),
        orElse: () => SortOrder.ascending,
      );
    }

    return ProductFilter(
      searchQuery: map["searchQuery"] as String?,
      category: map["category"] as String?,
      categories: map["categories"] != null
          ? List<String>.from(map["categories"] as List)
          : null,
      brand: map["brand"] as String?,
      brands: map["brands"] != null
          ? List<String>.from(map["brands"] as List)
          : null,
      tags: map["tags"] != null ? List<String>.from(map["tags"] as List) : null,
      minPrice: (map["minPrice"] as num?)?.toDouble(),
      maxPrice: (map["maxPrice"] as num?)?.toDouble(),
      minRating: (map["minRating"] as num?)?.toDouble(),
      maxRating: (map["maxRating"] as num?)?.toDouble(),
      availabilityStatus: map["availabilityStatus"] as String?,
      inStockOnly: map["inStockOnly"] as bool?,
      sortBy: parseSortBy(map["sortBy"]),
      sortOrder: parseSortOrder(map["sortOrder"]),
    );
  }

  factory ProductFilter.fromJson(String source) =>
      ProductFilter.fromMap(json.decode(source) as Map<String, dynamic>);

  final String? searchQuery;
  final String? category;
  final List<String>? categories;
  final String? brand;
  final List<String>? brands;
  final List<String>? tags;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final double? maxRating;
  final String? availabilityStatus;
  final bool? inStockOnly;
  final ProductSortBy? sortBy;
  final SortOrder sortOrder;

  ProductFilter copyWith({
    String? searchQuery,
    String? category,
    List<String>? categories,
    String? brand,
    List<String>? brands,
    List<String>? tags,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    double? maxRating,
    String? availabilityStatus,
    bool? inStockOnly,
    ProductSortBy? sortBy,
    SortOrder? sortOrder,
  }) {
    return ProductFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      category: category ?? this.category,
      categories: categories ?? this.categories,
      brand: brand ?? this.brand,
      brands: brands ?? this.brands,
      tags: tags ?? this.tags,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      maxRating: maxRating ?? this.maxRating,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      inStockOnly: inStockOnly ?? this.inStockOnly,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  /// Converts filter settings into HTTP query parameters map
  /// (for API requests like DummyJSON).
  Map<String, String> toQueryParams() {
    final params = <String, String>{};
    if (searchQuery != null && searchQuery!.trim().isNotEmpty) {
      params["q"] = searchQuery!.trim();
    }
    if (category != null && category!.trim().isNotEmpty) {
      params["category"] = category!.trim();
    }
    if (brand != null && brand!.trim().isNotEmpty) {
      params["brand"] = brand!.trim();
    }
    if (minPrice != null) {
      params["minPrice"] = minPrice.toString();
    }
    if (maxPrice != null) {
      params["maxPrice"] = maxPrice.toString();
    }
    if (minRating != null) {
      params["minRating"] = minRating.toString();
    }
    if (sortBy != null) {
      params["sortBy"] = sortBy!.value;
      params["order"] = sortOrder.value;
    }
    return params;
  }

  Map<String, dynamic> toMap() {
    return {
      "searchQuery": searchQuery,
      "category": category,
      "categories": categories,
      "brand": brand,
      "brands": brands,
      "tags": tags,
      "minPrice": minPrice,
      "maxPrice": maxPrice,
      "minRating": minRating,
      "maxRating": maxRating,
      "availabilityStatus": availabilityStatus,
      "inStockOnly": inStockOnly,
      "sortBy": sortBy?.value,
      "sortOrder": sortOrder.value,
    };
  }

  String toJson() => json.encode(toMap());

  /// Evaluates whether a [Product] satisfies all filter criteria.
  bool matches(Product product) {
    if (searchQuery != null && searchQuery!.trim().isNotEmpty) {
      final query = searchQuery!.toLowerCase().trim();
      final matchesTitle = product.title.toLowerCase().contains(query);
      final matchesDesc = product.description.toLowerCase().contains(query);
      final matchesBrand = product.brand.toLowerCase().contains(query);
      final matchesCategory = product.category.toLowerCase().contains(query);
      final matchesTags =
          product.tags.any((t) => t.toLowerCase().contains(query));
      if (!matchesTitle &&
          !matchesDesc &&
          !matchesBrand &&
          !matchesCategory &&
          !matchesTags) {
        return false;
      }
    }

    if (category != null && category!.trim().isNotEmpty) {
      if (product.category.toLowerCase() != category!.trim().toLowerCase()) {
        return false;
      }
    }

    if (categories != null && categories!.isNotEmpty) {
      final lowerCats = categories!.map((c) => c.toLowerCase()).toSet();
      if (!lowerCats.contains(product.category.toLowerCase())) {
        return false;
      }
    }

    if (brand != null && brand!.trim().isNotEmpty) {
      if (product.brand.toLowerCase() != brand!.trim().toLowerCase()) {
        return false;
      }
    }

    if (brands != null && brands!.isNotEmpty) {
      final lowerBrands = brands!.map((b) => b.toLowerCase()).toSet();
      if (!lowerBrands.contains(product.brand.toLowerCase())) {
        return false;
      }
    }

    if (tags != null && tags!.isNotEmpty) {
      final lowerFilterTags = tags!.map((t) => t.toLowerCase()).toSet();
      final hasMatchingTag =
          product.tags.any((t) => lowerFilterTags.contains(t.toLowerCase()));
      if (!hasMatchingTag) {
        return false;
      }
    }

    if (minPrice != null && product.price < minPrice!) {
      return false;
    }

    if (maxPrice != null && product.price > maxPrice!) {
      return false;
    }

    if (minRating != null && product.rating < minRating!) {
      return false;
    }

    if (maxRating != null && product.rating > maxRating!) {
      return false;
    }

    if (availabilityStatus != null && availabilityStatus!.trim().isNotEmpty) {
      if (product.availabilityStatus.toLowerCase() !=
          availabilityStatus!.trim().toLowerCase()) {
        return false;
      }
    }

    if (inStockOnly == true && product.stock <= 0) {
      return false;
    }

    return true;
  }

  /// Filters and sorts a given list of [Product] items locally
  /// according to this filter.
  List<Product> apply(List<Product> products) {
    final filtered = products.where(matches).toList();

    if (sortBy == null) {
      return filtered;
    }

    filtered.sort((a, b) {
      int comparison;
      switch (sortBy!) {
        case ProductSortBy.title:
          comparison = a.title.compareTo(b.title);
        case ProductSortBy.price:
          comparison = a.price.compareTo(b.price);
        case ProductSortBy.rating:
          comparison = a.rating.compareTo(b.rating);
        case ProductSortBy.category:
          comparison = a.category.compareTo(b.category);
        case ProductSortBy.brand:
          comparison = a.brand.compareTo(b.brand);
        case ProductSortBy.discountPercentage:
          comparison = a.discountPercentage.compareTo(b.discountPercentage);
        case ProductSortBy.stock:
          comparison = a.stock.compareTo(b.stock);
      }
      return sortOrder == SortOrder.ascending ? comparison : -comparison;
    });

    return filtered;
  }

  bool get hasActiveFilter =>
      searchQuery != null &&
      searchQuery!.trim().isNotEmpty &&
      category != null &&
      category!.trim().isNotEmpty &&
      categories != null &&
      categories!.isNotEmpty &&
      brand != null &&
      brand!.trim().isNotEmpty &&
      brands != null &&
      brands!.isNotEmpty &&
      tags != null &&
      tags!.isNotEmpty &&
      minPrice != null &&
      maxPrice != null &&
      minRating != null &&
      maxRating != null &&
      availabilityStatus != null &&
      availabilityStatus!.trim().isNotEmpty &&
      inStockOnly != null &&
      inStockOnly == true &&
      sortBy != null &&
      sortOrder != SortOrder.ascending;

  @override
  String toString() {
    return "ProductFilter(searchQuery: $searchQuery, category: $category, "
        "categories: $categories, brand: $brand, brands: $brands, tags: $tags, "
        "minPrice: $minPrice, maxPrice: $maxPrice, minRating: $minRating, "
        "maxRating: $maxRating, availabilityStatus: $availabilityStatus, "
        "inStockOnly: $inStockOnly, sortBy: $sortBy, sortOrder: $sortOrder)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductFilter &&
        other.searchQuery == searchQuery &&
        other.category == category &&
        listEquals(other.categories, categories) &&
        other.brand == brand &&
        listEquals(other.brands, brands) &&
        listEquals(other.tags, tags) &&
        other.minPrice == minPrice &&
        other.maxPrice == maxPrice &&
        other.minRating == minRating &&
        other.maxRating == maxRating &&
        other.availabilityStatus == availabilityStatus &&
        other.inStockOnly == inStockOnly &&
        other.sortBy == sortBy &&
        other.sortOrder == sortOrder;
  }

  @override
  int get hashCode {
    return Object.hash(
      searchQuery,
      category,
      Object.hashAll(categories ?? []),
      brand,
      Object.hashAll(brands ?? []),
      Object.hashAll(tags ?? []),
      minPrice,
      maxPrice,
      minRating,
      maxRating,
      availabilityStatus,
      inStockOnly,
      sortBy,
      sortOrder,
    );
  }
}
