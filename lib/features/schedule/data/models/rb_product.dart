class RBProduct {
  String? id;
  String? name;
  String? size;
  int? quantity;
  String? imgUrl;

  RBProduct({this.id, this.name, this.size, this.quantity, this.imgUrl});

  factory RBProduct.fromJson(Map<String, dynamic> json) {
    return RBProduct(
      id: json['id'],
      name: json['name'],
      size: json['size'],
      quantity: json['quantity'],
      imgUrl: json['imgUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'size': size,
      'quantity': quantity,
      'imgUrl': imgUrl,
    };
  }
}
