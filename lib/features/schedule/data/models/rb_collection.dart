import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recycla_bin/features/schedule/data/models/rb_product.dart';

import 'rb_collection_product.dart';

enum CollectionStatus {
  Pending,
  Paid,
  Collected,
  Canceled,
}


class RBCollection {
  String? id;
  String? date;
  String? time;
  String? address;
  String? lat;
  String? lon;
  List<RBCollectionProduct>? collectionProducts;
  CollectionStatus status;
  List<RBProduct>? products;

  RBCollection({
    this.id,
    this.date,
    this.time,
    this.address,
    this.lat,
    this.lon,
    this.collectionProducts,
    this.products,
    this.status = CollectionStatus.Pending,});

  factory RBCollection.fromJson(Map<String, dynamic> json) {
    var productList = json['collectionProducts'] as List?;
    List<RBCollectionProduct>? collectionProducts = productList != null
        ? productList.map((product) => RBCollectionProduct.fromJson(product)).toList()
        : null;

    var productsList = json['products'] as List?;
    List<RBProduct>? products = productsList != null
        ? productsList.map((product) => RBProduct.fromJson(product)).toList()
        : null;

    return RBCollection(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      address: json['address'],
      lat: json['lat'],
      lon: json['lon'],
      products: products,
      collectionProducts: collectionProducts,
      status: CollectionStatus.values[json['status']], // Deserialize enum
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
      'status': status.index, // Serialize enum as an integer
      // 'products': products,
      'collectionProducts': collectionProducts?.map((product) => product.toJson()).toList(),
    };
  }

  RBCollection copyWith({
    String? id,
    String? date,
    String? time,
    String? address,
    String? lat,
    String? lon,
    List<RBCollectionProduct>? collectionProducts,
    List<RBProduct>? products,
    CollectionStatus? status,
  }) {
    return RBCollection(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      status: status ?? this.status,
      products: products ?? this.products,
      collectionProducts: collectionProducts ?? this.collectionProducts,
    );
  }

  factory RBCollection.fromDocument(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    var productList = data['collectionProducts'] as List?;
    List<RBCollectionProduct>? collectionProducts = productList != null
        ? productList.map((product) => RBCollectionProduct.fromJson(product)).toList()
        : null;

    // var productsList = data['products'] as List?;
    // List<RBProduct>? products = productsList != null
    //     ? productsList.map((product) => RBProduct.fromJson(product)).toList()
    //     : null;

    return RBCollection(
      id: data['id'],
      date: data['date'],
      time: data['time'],
      address: data['address'],
      lat: data['lat'],
      lon: data['lon'],
      // products: products,
      status: CollectionStatus.values[data['status']],
      collectionProducts: collectionProducts,
    );
  }

  int getTotalQuantity() {
    if (collectionProducts != null) {
      return collectionProducts!.fold(0, (sum, item) => sum + (item.quantity ?? 0));
    }
    return 0;
  }

  int getNumberOfProducts() {
    if (collectionProducts != null) {
      return collectionProducts!.length;
    }
    return 0;
  }

  String? getFirstProductImage() {
    // Assuming the first product in the collection is the first product in the list
    if (collectionProducts != null && collectionProducts!.isNotEmpty) {
      // Add logic here to fetch the image URL of the first product
      // This would typically require accessing the product information by productId
      return null; // Replace with actual logic
    }
    return null;
  }

  Color? getStatusColor() {
    switch (status) {
      case CollectionStatus.Pending:
        return Colors.orange.shade400;
      case CollectionStatus.Paid:
        return Colors.blue;
      case CollectionStatus.Collected:
        return Colors.green;
      case CollectionStatus.Canceled:
        return Colors.red.shade200; // Light Red
      default:
        return Colors.white; // Default color if status is not recognized
    }
  }

  double calculateCost() {
    double totalCost = 0.0;
    if (products != null) {
      for (var product in products!) {
        double sizeInLiters = _parseSizeToLiters(product.size ?? '');
        totalCost += sizeInLiters * 24 * (product.quantity ?? 1);
      }
    }
    return double.parse(totalCost.toStringAsFixed(2));
  }

  double calculateTotalWight() {
    double totalLitres = 0.0;
    if (products != null) {
      for (var product in products!) {
        totalLitres += _parseSizeToLiters(product.size ?? '');
        // totalCost += sizeInLiters * 24 * (product.quantity ?? 1);
      }
    }
    return double.parse(totalLitres.toStringAsFixed(2));
  }

  double _parseSizeToLiters(String size) {
    double value = 0.0;
    if (size.isEmpty) return value;

    final regex = RegExp(r'(\d+\.?\d*)\s*(ml|l|g|kg)', caseSensitive: false);
    final match = regex.firstMatch(size);

    if (match != null) {
      value = double.parse(match.group(1) ?? '0');
      String unit = match.group(2)?.toLowerCase() ?? '';

      switch (unit) {
        case 'ml':
          value /= 1000; // Convert ml to liters
          break;
        case 'l':
        // value is already in liters
          break;
        case 'g':
          value /= 1000; // Convert grams to kilograms
          break;
        case 'kg':
        // 1 kg is considered equivalent to 1 liter for the sake of pricing
          break;
        default:
          value = 0.0; // Default to 0 if the unit is not recognized
      }
    }
    return value;
  }

  String getCollectionStatusString(){
    return status.toString().split('.').last;
  }
}
