import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import '../../data/models/rb_product.dart';
import '../../domain/repositories/rb_collection_repository.dart';
import '../../data/models/rb_collection.dart';

class RBCollectionProvider with ChangeNotifier {
  final RBCollectionRepository repository;
  RBCollection? _collection;

  RBCollectionProvider({required this.repository}) {
    loadCollection();
  }

  RBCollection? get collection => _collection;

  Future<void> loadCollection() async {
    _collection = await repository.getCollection();
    notifyListeners();
  }

  Future<void> saveCollection(RBCollection collection) async {
    await repository.saveCollection(collection);
    _collection = collection;
    notifyListeners();
  }

  Future<void> updateCollection({
    String? date,
    String? time,
    String? address,
    String? lat,
    String? lon,
    List<RBProduct>? products,
  }) async {
    if (_collection != null) {
      _collection = _collection!.copyWith(
        date: date ?? _collection!.date,
        time: time ?? _collection!.time,
        address: address ?? _collection!.address,
        lat: lat ?? _collection!.lat,
        lon: lon ?? _collection!.lon,
        products: products ?? _collection!.products,
      );
      await repository.saveCollection(_collection!);
      notifyListeners();
    }
  }

  Future<void> removeCollection() async {
    await repository.removeCollection();
    _collection = null;
    notifyListeners();
  }

  void addProduct(RBProduct product) {
    if (_collection != null) {
      if (_collection!.products == null) {
        _collection = _collection!.copyWith(products: [product]);
      } else {
        // Check if the product already exists
        final existingProductIndex = _collection!.products!.indexWhere((p) => p.id == product.id);

        if (existingProductIndex != -1) {
          _collection!.products![existingProductIndex].quantity = (_collection!.products![existingProductIndex].quantity ?? 0) + 1;
        } else {
          product.quantity = 1;
          _collection!.products!.add(product);
        }
      }
      saveCollection(_collection!);
    }
  }

  void removeProduct(RBProduct product) {
    if (_collection != null && _collection!.products != null) {
      _collection!.products!.removeWhere((p) => p.id == product.id);
      saveCollection(_collection!);
    }
  }

  void incrementProductCount(RBProduct product) {
    if (_collection != null) {
      final existingProductIndex = _collection!.products!.indexWhere((p) => p.id == product.id);
      if (existingProductIndex != -1) {
        _collection!.products![existingProductIndex].quantity = (_collection!.products![existingProductIndex].quantity ?? 0) + 1;
        saveCollection(_collection!);
      }
    }
  }

  void decrementProductCount(RBProduct product) {
    if (_collection != null) {
      final existingProductIndex = _collection!.products!.indexWhere((p) => p.id == product.id);
      if (existingProductIndex != -1 && (_collection!.products![existingProductIndex].quantity ?? 0) > 0) {
        _collection!.products![existingProductIndex].quantity = (_collection!.products![existingProductIndex].quantity ?? 0) - 1;
        if (_collection!.products![existingProductIndex].quantity == 0) {
          _collection!.products!.removeAt(existingProductIndex);
        }
        saveCollection(_collection!);
      }
    }
  }

  bool areAllFieldsFilled() {
    return _collection != null &&
        _collection!.date != null &&
        _collection!.time != null &&
        _collection!.address != null &&
        _collection!.lat != null &&
        _collection!.lon != null &&
        _collection!.products != null &&
        _collection!.products!.isNotEmpty;
  }

  int getTotalQuantity() {
    if (_collection != null && _collection!.products != null) {
      return _collection!.products!.fold(0, (sum, item) => sum + (item.quantity ?? 0));
    }
    return 0;
  }

  int getNumberOfProducts() {
    if (_collection != null && _collection!.products != null) {
      return _collection!.products!.length;
    }
    return 0;
  }
}
