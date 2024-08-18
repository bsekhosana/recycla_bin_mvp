class RBCollectionProduct {
  String productId;
  int quantity;

  RBCollectionProduct({required this.productId,required this.quantity});

  factory RBCollectionProduct.fromJson(Map<String, dynamic> json) {
    return RBCollectionProduct(
      productId: json['productId'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }

  @override
  String toString() {
    return 'RBCollectionProduct{'
        'productId: $productId, '
        'quantity: $quantity}';
  }
}
