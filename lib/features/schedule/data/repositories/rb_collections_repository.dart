import 'package:recycla_bin/core/services/firestore_repository_service.dart';

import '../models/rb_collection.dart';
import '../models/rb_product.dart';

class RBCollectionsRepository {
  
  final FirestoreRepository _firestoreRepository = FirestoreRepository(collectionPath: 'collections');

  Future<List<RBCollection>> fetchCollections(String userId) async {
    try {
      List<RBCollection> collections = await _firestoreRepository.fetchAllDocumentsWithId(
        'userId',
        userId,
            (data) {
          data['productIds'] = data['products'];
          data['products'] = null;
          return RBCollection.fromJson(data);
        },
      ).then((value) => value.cast<RBCollection>());
      print('found collections ${collections}');
      for (var collection in collections) {
        if (collection.productIds != null) {
          List<RBProduct> products = [];
          for (var productId in collection.productIds!) {
            var product = await _firestoreRepository.readDocument(productId, (data) {
              print('single product ${data}');
              return RBProduct.fromJson(data);
            }) as RBProduct;
            if (product != null) {
              products.add(product);
            }
          }
          collection.products = products;
        }
      }

      return collections;
    } catch (e) {
      throw "Fetching collections for user id:$userId failed with error: ${e.toString()}";
    }
  }
}