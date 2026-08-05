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
      id: map["id"] as int? ?? 0,
      title: map["title"] as String? ?? "",
      description: map["description"] as String? ?? "",
      category: map["category"] as String? ?? "",
      price: map["price"] as double? ?? 0.0,
      discountPercentage: map["discountPercentage"] as double? ?? 0.0,
      rating: map["rating"] as double? ?? 0.0,
      stock: map["stock"] as int? ?? 0,
      tags: List<String>.from(map["tags"] as List<dynamic>),
      brand: map["brand"] as String? ?? "",
      sku: map["sku"] as String? ?? "",
      weight: map["weight"] as int? ?? 0,
      dimensions: Dimensions.fromMap(map["dimensions"] as Map<String, dynamic>),
      warrantyInformation: map["warrantyInformation"] as String? ?? "",
      shippingInformation: map["shippingInformation"] as String? ?? "",
      availabilityStatus: map["availabilityStatus"] as String? ?? "",
      returnPolicy: map["returnPolicy"] as String? ?? "",
      minimumOrderQuantity: map["minimumOrderQuantity"] as int? ?? 0,
      meta: Meta.fromMap(map["meta"] as Map<String, dynamic>),
      images: List<String>.from(map["images"] as List<dynamic>),
      thumbnail: map["thumbnail"] as String? ?? "",
    );
  }

  factory Product.fromJson(String source) =>
      Product.fromMap(jsonDecode(source) as Map<String, dynamic>);
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
      width: map["width"] as double? ?? 0.0,
      height: map["height"] as double? ?? 0.0,
      depth: map["depth"] as double? ?? 0.0,
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

  factory Meta.fromMap(Map<String, dynamic> map) {
    return Meta(
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map["createdAt"] as int? ?? 0,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map["updatedAt"] as int? ?? 0,
      ),
      barcode: map["barcode"] as String? ?? "",
      qrCode: map["qrCode"] as String? ?? "",
    );
  }

  factory Meta.fromJson(String source) =>
      Meta.fromMap(jsonDecode(source) as Map<String, dynamic>);
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
