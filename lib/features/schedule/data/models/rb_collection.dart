import 'package:cloud_firestore/cloud_firestore.dart';

import 'rb_product.dart';

class RBCollection {
  String? id;
  String? date;
  String? time;
  String? address;
  String? lat;
  String? lon;
  List<String>? productIds;
  List<RBProduct>? products;

  RBCollection({this.id, this.date, this.time, this.productIds, this.address, this.products, this.lat, this.lon});

  factory RBCollection.fromJson(Map<String, dynamic> json) {
    var productList = json['products'] as List?;
    List<RBProduct>? products = productList != null
        ? productList.map((product) => RBProduct.fromJson(product)).toList()
        : null;

    var productListIds = json['productIds'] as List?;
    List<String>? productIds = productListIds != null ? List<String>.from(productListIds.map((e) => e.toString())) : null;

    return RBCollection(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      address: json['address'],
      lat: json['lat'],
      lon: json['lon'],
      productIds: productIds,
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
      'productIds': productIds,
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
    List<String>? productIds
  }) {
    return RBCollection(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      products: products ?? this.products,
      productIds: productIds ?? this.productIds,
    );
  }

  factory RBCollection.fromDocument(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    var productList = data['products'] as List?;
    List<RBProduct>? products = productList != null
        ? productList.map((product) => RBProduct.fromJson(product)).toList()
        : null;

    var productListIds = data['productIds'] as List?;
    List<String>? productIds = productListIds != null ? List<String>.from(productListIds.map((e) => e.toString())) : null;

    return RBCollection(
      id: data['id'],
      date: data['date'],
      time: data['time'],
      address: data['address'],
      lat: data['lat'],
      lon: data['lon'],
      products: products,
      productIds: productIds
    );
  }

  int getTotalQuantity() {
    if (products != null) {
      return products!.fold(0, (sum, item) => sum + (item.quantity ?? 0));
    }
    return 0;
  }

  int getNumberOfProducts() {
    if (products != null) {
      return products!.length;
    }
    return 0;
  }
}
