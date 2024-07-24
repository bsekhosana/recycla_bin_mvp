import 'rb_product.dart';

class RBCollection {
  String? id;
  String? date;
  String? time;
  String? address;
  String? lat;
  String? lon;
  List<RBProduct>? products;

  RBCollection({this.id, this.date, this.time, this.address, this.products, this.lat, this.lon});

  factory RBCollection.fromJson(Map<String, dynamic> json) {
    var productList = json['products'] as List?;
    List<RBProduct>? products = productList != null
        ? productList.map((product) => RBProduct.fromJson(product)).toList()
        : null;

    return RBCollection(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      address: json['address'],
      lat: json['lat'],
      lon: json['lon'],
      products: products,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'address': address,
      'lat': lat,
      'lon': lon,
      'products': products?.map((product) => product.toJson()).toList(),
    };
  }

  RBCollection copyWith({
    String? id,
    String? date,
    String? time,
    String? address,
    String? lat,
    String? lon,
    List<RBProduct>? products,
  }) {
    return RBCollection(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      products: products ?? this.products,
    );
  }
}
