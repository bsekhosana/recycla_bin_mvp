import 'package:flutter/material.dart';

import '../../../core/services/connectivity_service.dart';
import '../data/models/rb_collection.dart';
import '../data/repositories/rb_collection_repository.dart';
import '../data/repositories/rb_collections_repository.dart';

class RBCollectionsProvider with ChangeNotifier{

  final RBCollectionsRepository repository = RBCollectionsRepository();

  List<RBCollection> _collections = [];

  List<RBCollection> get collections => _collections;

  final ConnectivityService _connectivityService = ConnectivityService();

  Future<void> fetchCollections(String userId) async {
    try {
      if (await _connectivityService.checkConnectivity()) {
        _collections = await repository.fetchCollections(userId);
        notifyListeners();
        if (_collections.isEmpty) {
          throw Exception("No collections found");
        }
      }else{
        throw Exception("No internet connection");
      }
    } catch (e) {
      rethrow;
    }
  }
}