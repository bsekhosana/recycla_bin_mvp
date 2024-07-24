import 'rb_product.dart';

class RBCollection {
  String? id;
  String? date;
  String? time;
  String? location;
  List<RBProduct>? products;

  RBCollection({this.id, this.date, this.time, this.location, this.products});

  factory RBCollection.fromJson(Map<String, dynamic> json) {
    var productList = json['products'] as List?;
    List<RBProduct>? products = productList != null
        ? productList.map((product) => RBProduct.fromJson(product)).toList()
        : null;

    return RBCollection(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      location: json['location'],
      products: products,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'location': location,
      'products': products?.map((product) => product.toJson()).toList(),
    };
  }
}
