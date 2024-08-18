import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:recycla_bin/features/schedule/data/repositories/rb_product_repository.dart';
import '../../../core/services/connectivity_service.dart';
import '../data/models/rb_product.dart';
import '../data/repositories/rb_collection_repository.dart';
import '../data/models/rb_collection.dart';
import '../data/models/rb_collection_product.dart';

class RBCollectionProvider with ChangeNotifier {
  final RBCollectionRepository repository;
  RBCollection? _collection;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ConnectivityService _connectivityService = ConnectivityService();

  RBProductRepository _productRepository;  // Initialized in the constructor

  RBCollectionProvider({required this.repository})
      : _productRepository = RBProductRepository() {
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
    List<RBCollectionProduct>? collectionProducts,
  }) async {
    if (_collection != null) {
      _collection = _collection!.copyWith(
        date: date ?? _collection!.date,
        time: time ?? _collection!.time,
        address: address ?? _collection!.address,
        lat: lat ?? _collection!.lat,
        lon: lon ?? _collection!.lon,
        collectionProducts: collectionProducts ?? _collection!.collectionProducts,
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

  void addProduct(RBProduct product, int quantity) async {
    try {

    final productDoc = await _productRepository.getProductById(
      product.id!,
    );

    // Check if the product already exists in Firestore
    if (productDoc == null) {
      // If the product doesn't exist in Firestore, add it
      await _productRepository.saveProduct(product);
      print('Product added to Firestore');
    } else {
      print('Product already exists in Firestore');
    }

    if (_collection != null) {
        // Proceed with adding/updating the product in the collection
        if (_collection!.collectionProducts == null) {
          print('collection products equals to null');
          _collection = _collection!.copyWith(collectionProducts: [
            RBCollectionProduct(
              productId: product.id!,
              quantity: quantity,
            )], products: [
              product
          ]);
        } else {
          // Check if the product already exists in the collection
          final existingProductIndex =
          _collection!.collectionProducts!.indexWhere((p) => p.productId == product.id);
          print('collection products equals not null, existingProductIndex: $existingProductIndex');
          if (existingProductIndex != -1) {
            // If it exists, update the quantity
            _collection!.collectionProducts![existingProductIndex].quantity =
                (_collection!.collectionProducts![existingProductIndex].quantity ?? 0) + quantity;
          } else {
            // If it doesn't exist, add it to the collection
            _collection!.collectionProducts!.add(RBCollectionProduct(
              productId: product.id!,
              quantity: quantity,
            ));

            _collection!.products!.add(product);
          }
        }

        // Save the updated collection
        saveCollection(_collection!);

        print('saveCollection: ${_collection!.toJson()}');

      }else{

        _collection = RBCollection(collectionProducts: [
          RBCollectionProduct(
            productId: product.id!,
            quantity: quantity,
          )],
          products: [product]
        );

        // Save the updated collection
        saveCollection(_collection!);

        print('created new collection: ${_collection!.toJson()}');

      }
    } catch (e) {
      throw 'Failed to add product to collection, with error: ${e.toString()}';
    }
  }


  void removeProduct(RBProduct product) {
    if (_collection != null && _collection!.collectionProducts != null) {
      _collection!.collectionProducts!.removeWhere((p) => p.productId == product.id);
      _collection!.products!.removeWhere((p) => p.id == product.id);
      saveCollection(_collection!);
    }
  }

  void incrementProductCount(RBProduct product) {
    if (_collection != null) {
      final existingProductIndex = _collection!.collectionProducts!.indexWhere((p) => p.productId == product.id);
      if (existingProductIndex != -1) {
        _collection!.collectionProducts![existingProductIndex].quantity = (_collection!.collectionProducts![existingProductIndex].quantity ?? 0) + 1;
        saveCollection(_collection!);
      }
    }
  }

  void decrementProductCount(RBProduct product) {
    if (_collection != null) {
      final existingProductIndex = _collection!.collectionProducts!.indexWhere((p) => p.productId == product.id);
      if (existingProductIndex != -1 && (_collection!.collectionProducts![existingProductIndex].quantity ?? 0) > 0) {
        _collection!.collectionProducts![existingProductIndex].quantity = (_collection!.collectionProducts![existingProductIndex].quantity ?? 0) - 1;
        if (_collection!.collectionProducts![existingProductIndex].quantity == 0) {
          _collection!.collectionProducts!.removeAt(existingProductIndex);
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
        _collection!.collectionProducts != null &&
        _collection!.collectionProducts!.isNotEmpty;
  }

  int getTotalQuantity() {
    if (_collection != null && _collection!.collectionProducts != null) {
      return _collection!.collectionProducts!.fold(0, (sum, item) => sum + (item.quantity ?? 0));
    }
    return 0;
  }

  int getNumberOfProducts() {
    if (_collection != null && _collection!.collectionProducts != null) {
      return _collection!.collectionProducts!.length;
    }
    return 0;
  }

  Future<void> saveCollectionToFirestore(String userId) async {
    try {
      if (await _connectivityService.checkConnectivity()) {
        if (_collection == null) {
          throw Exception('Unable to save empty collection to firebase');
        }
        await repository.saveCollectionToFirestore(_collection!, userId);
      } else {
        throw Exception("No internet connection");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeCollectionFromCache() async {
    await repository.removeCollection();
    _collection = null;
    notifyListeners();
  }

  Future<RBProduct?> fetchProductById(String productId) async {
    try {
      final productDoc = await _firestore.collection('products').doc(productId).get();
      if (productDoc.exists) {
        return RBProduct.fromJson(productDoc.data()!);
      }
      return null;
    } catch (e) {
      throw 'Error fetching product by ID: ${e.toString()}';
    }
  }

  Future<void> saveProduct(RBProduct product) async {
    try {
      await _productRepository.saveProduct(product);
      print('saveProduct in collection provider');
    } catch (e) {
      throw 'Error saving product: ${e.toString()}';
    }
  }
}
