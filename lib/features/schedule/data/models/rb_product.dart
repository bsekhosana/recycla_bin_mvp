class RBProduct {
  String? id;
  String? name;
  String? size;
  int? quantity;

  RBProduct({this.id, this.name, this.size, this.quantity});

  factory RBProduct.fromJson(Map<String, dynamic> json) {
    return RBProduct(
      id: json['id'],
      name: json['name'],
      size: json['size'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'size': size,
      'quantity': quantity,
    };
  }
}
