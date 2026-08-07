// ignore_for_file: avoid_annotating_with_dynamic

import "dart:convert";

import "package:flutter/foundation.dart";

class Product {
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.meta,
    required this.images,
    required this.thumbnail,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: _parseInt(map["id"], 0),
      title: map["title"]?.toString() ?? "",
      description: map["description"]?.toString() ?? "",
      category: map["category"]?.toString() ?? "",
      price: _parseDouble(map["price"], 0.0),
      discountPercentage: _parseDouble(map["discountPercentage"], 0.0),
      rating: _parseDouble(map["rating"], 0.0),
      stock: _parseInt(map["stock"], 0),
      tags:
          (map["tags"] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      brand: map["brand"]?.toString() ?? "",
      sku: map["sku"]?.toString() ?? "",
      weight: _parseInt(map["weight"], 0),
      dimensions: Dimensions.fromMap(
        map["dimensions"] as Map<String, dynamic>? ?? {},
      ),
      warrantyInformation: map["warrantyInformation"]?.toString() ?? "",
      shippingInformation: map["shippingInformation"]?.toString() ?? "",
      availabilityStatus: map["availabilityStatus"]?.toString() ?? "",
      returnPolicy: map["returnPolicy"]?.toString() ?? "",
      minimumOrderQuantity: _parseInt(map["minimumOrderQuantity"], 0),
      meta: Meta.fromMap(map["meta"] as Map<String, dynamic>? ?? {}),
      images:
          (map["images"] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      thumbnail: map["thumbnail"]?.toString() ?? "",
    );
  }

  factory Product.fromJson(String source) =>
      Product.fromMap(jsonDecode(source) as Map<String, dynamic>);

  static int _parseInt(dynamic value, int defaultValue) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  static double _parseDouble(dynamic value, double defaultValue) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String brand;
  final String sku;
  final int weight;
  final Dimensions dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final String returnPolicy;
  final int minimumOrderQuantity;
  final Meta meta;
  final List<String> images;
  final String thumbnail;

  Product copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    double? price,
    double? discountPercentage,
    double? rating,
    int? stock,
    List<String>? tags,
    String? brand,
    String? sku,
    int? weight,
    Dimensions? dimensions,
    String? warrantyInformation,
    String? shippingInformation,
    String? availabilityStatus,
    String? returnPolicy,
    int? minimumOrderQuantity,
    Meta? meta,
    List<String>? images,
    String? thumbnail,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      rating: rating ?? this.rating,
      stock: stock ?? this.stock,
      tags: tags ?? this.tags,
      brand: brand ?? this.brand,
      sku: sku ?? this.sku,
      weight: weight ?? this.weight,
      dimensions: dimensions ?? this.dimensions,
      warrantyInformation: warrantyInformation ?? this.warrantyInformation,
      shippingInformation: shippingInformation ?? this.shippingInformation,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      returnPolicy: returnPolicy ?? this.returnPolicy,
      minimumOrderQuantity: minimumOrderQuantity ?? this.minimumOrderQuantity,
      meta: meta ?? this.meta,
      images: images ?? this.images,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "category": category,
      "price": price,
      "discountPercentage": discountPercentage,
      "rating": rating,
      "stock": stock,
      "tags": tags,
      "brand": brand,
      "sku": sku,
      "weight": weight,
      "dimensions": dimensions.toMap(),
      "warrantyInformation": warrantyInformation,
      "shippingInformation": shippingInformation,
      "availabilityStatus": availabilityStatus,
      "returnPolicy": returnPolicy,
      "minimumOrderQuantity": minimumOrderQuantity,
      "meta": meta.toMap(),
      "images": images,
      "thumbnail": thumbnail,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return "Product(id: $id, title: $title, description: $description, "
        "category: $category, price: $price, discountPercentage: "
        "$discountPercentage, rating: $rating, stock: $stock, tags: "
        "$tags, brand: $brand, sku: $sku, weight: $weight, dimensions: "
        "$dimensions, warrantyInformation: $warrantyInformation, "
        "shippingInformation: $shippingInformation, availabilityStatus: "
        "$availabilityStatus, returnPolicy: $returnPolicy, "
        "minimumOrderQuantity: $minimumOrderQuantity, meta: $meta, "
        "images: $images, thumbnail: $thumbnail)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.category == category &&
        other.price == price &&
        other.discountPercentage == discountPercentage &&
        other.rating == rating &&
        other.stock == stock &&
        listEquals(other.tags, tags) &&
        other.brand == brand &&
        other.sku == sku &&
        other.weight == weight &&
        other.dimensions == dimensions &&
        other.warrantyInformation == warrantyInformation &&
        other.shippingInformation == shippingInformation &&
        other.availabilityStatus == availabilityStatus &&
        other.returnPolicy == returnPolicy &&
        other.minimumOrderQuantity == minimumOrderQuantity &&
        other.meta == meta &&
        listEquals(other.images, images) &&
        other.thumbnail == thumbnail;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        category.hashCode ^
        price.hashCode ^
        discountPercentage.hashCode ^
        rating.hashCode ^
        stock.hashCode ^
        tags.hashCode ^
        brand.hashCode ^
        sku.hashCode ^
        weight.hashCode ^
        dimensions.hashCode ^
        warrantyInformation.hashCode ^
        shippingInformation.hashCode ^
        availabilityStatus.hashCode ^
        returnPolicy.hashCode ^
        minimumOrderQuantity.hashCode ^
        meta.hashCode ^
        images.hashCode ^
        thumbnail.hashCode;
  }
}

class Dimensions {
  Dimensions({required this.width, required this.height, required this.depth});

  factory Dimensions.fromMap(Map<String, dynamic> map) {
    return Dimensions(
      width: (map["width"] as num?)?.toDouble() ?? 0.0,
      height: (map["height"] as num?)?.toDouble() ?? 0.0,
      depth: (map["depth"] as num?)?.toDouble() ?? 0.0,
    );
  }

  factory Dimensions.fromJson(String source) =>
      Dimensions.fromMap(jsonDecode(source) as Map<String, dynamic>);
  final double width;
  final double height;
  final double depth;

  Dimensions copyWith({double? width, double? height, double? depth}) {
    return Dimensions(
      width: width ?? this.width,
      height: height ?? this.height,
      depth: depth ?? this.depth,
    );
  }

  Map<String, dynamic> toMap() {
    return {"width": width, "height": height, "depth": depth};
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      "Dimensions(width: $width, height: $height, depth: $depth)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Dimensions &&
        other.width == width &&
        other.height == height &&
        other.depth == depth;
  }

  @override
  int get hashCode => width.hashCode ^ height.hashCode ^ depth.hashCode;
}

class Meta {
  Meta({
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });

  factory Meta.fromJson(String source) =>
      Meta.fromMap(jsonDecode(source) as Map<String, dynamic>);

  factory Meta.fromMap(Map<String, dynamic> map) {
    return Meta(
      createdAt: _parseDateTime(map["createdAt"]),
      updatedAt: _parseDateTime(map["updatedAt"]),
      barcode: map["barcode"]?.toString() ?? "",
      qrCode: map["qrCode"]?.toString() ?? "",
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is String) return DateTime.tryParse(value) ?? DateTime(0);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return DateTime(0);
  }
  final DateTime createdAt;
  final DateTime updatedAt;
  final String barcode;
  final String qrCode;

  Meta copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    String? barcode,
    String? qrCode,
  }) {
    return Meta(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      barcode: barcode ?? this.barcode,
      qrCode: qrCode ?? this.qrCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "createdAt": createdAt.millisecondsSinceEpoch,
      "updatedAt": updatedAt.millisecondsSinceEpoch,
      "barcode": barcode,
      "qrCode": qrCode,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return "Meta(createdAt: $createdAt, updatedAt: $updatedAt, barcode: "
        "$barcode, qrCode: $qrCode)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Meta &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.barcode == barcode &&
        other.qrCode == qrCode;
  }

  @override
  int get hashCode {
    return createdAt.hashCode ^
        updatedAt.hashCode ^
        barcode.hashCode ^
        qrCode.hashCode;
  }
}
