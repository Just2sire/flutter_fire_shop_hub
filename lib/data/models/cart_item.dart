import "dart:convert";

import "package:shop_hub/data/models/product.dart";

class CartItem {
  CartItem({required this.product, required this.quantity});

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: Product.fromMap(map["product"] as Map<String, dynamic>),
      quantity: map["quantity"] as int? ?? 0,
    );
  }

  factory CartItem.fromJson(String source) =>
      CartItem.fromMap(json.decode(source) as Map<String, dynamic>);

  Product product;
  int quantity;

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() => {
    "product": product.toJson(),
    "quantity": quantity,
  };

  Map<String, dynamic> toMap() {
    return {"product": product.toMap(), "quantity": quantity};
  }

  @override
  String toString() => "CartItem(product: $product, quantity: $quantity)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartItem &&
        other.product == product &&
        other.quantity == quantity;
  }

  double get totalPrice => product.price * quantity;

  @override
  int get hashCode => product.hashCode ^ quantity.hashCode;
}
