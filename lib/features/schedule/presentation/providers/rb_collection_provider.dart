import 'package:flutter/material.dart';
import '../../data/models/rb_product.dart';
import '../../domain/repositories/rb_collection_repository.dart';
import '../../data/models/rb_collection.dart';

class RBCollectionProvider with ChangeNotifier {
  final RBCollectionRepository repository;
  RBCollection? _collection;

  RBCollectionProvider({required this.repository}) {
    _loadCollection();
  }

  RBCollection? get collection => _collection;

  Future<void> _loadCollection() async {
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
}
