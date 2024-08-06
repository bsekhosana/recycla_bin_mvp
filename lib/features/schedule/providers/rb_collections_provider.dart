import 'package:flutter/material.dart';

import '../../../core/services/connectivity_service.dart';
import '../data/models/rb_collection.dart';
import '../data/repositories/rb_collection_repository.dart';
import '../data/repositories/rb_collections_repository.dart';

class RBCollectionsProvider with ChangeNotifier{

  final RBCollectionsRepository repository = RBCollectionsRepository();

  List<RBCollection> _collections = [];

  List<RBCollection> get collections => _collections;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  final ConnectivityService _connectivityService = ConnectivityService();

  Future<void> fetchCollections(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (await _connectivityService.checkConnectivity()) {
        _collections = await repository.fetchCollections(userId);
        notifyListeners();
        if (_collections.isEmpty) {
          throw Exception("No collections found");
        }
      }else{
        notifyListeners();
        throw Exception("No internet connection");
      }
    } catch (e) {
      rethrow;
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}