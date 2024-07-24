import 'package:flutter/material.dart';
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

  Future<void> removeCollection() async {
    await repository.removeCollection();
    _collection = null;
    notifyListeners();
  }
}
