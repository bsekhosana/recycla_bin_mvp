import 'package:recycla_bin/core/services/firestore_repository_service.dart';
import '../models/rb_collection.dart';
import '../models/rb_product.dart';

class RBCollectionsRepository {
  final FirestoreRepository _firestoreRepository = FirestoreRepository(collectionPath: 'collections');
  final FirestoreRepository _productRepository = FirestoreRepository(collectionPath: 'products');

  Future<List<RBCollection>> fetchCollections(String userId) async {
    try {
      List<RBCollection> collections = await _firestoreRepository.fetchAllDocumentsWithId(
        'userId',
        userId,
            (data) {
          data['productIds'] = data['products'];
          data['products'] = null; // Reset products for later population
          return RBCollection.fromJson(data);
        },
      ).then((value) => value.cast<RBCollection>());

      for (var collection in collections) {
        if (collection.productIds != null) {
          List<RBProduct> products = [];
          for (var productId in collection.productIds!) {
            var product = await _productRepository.readDocument(
              productId,
                  (prodData) => RBProduct.fromJson(prodData),
            );
            if (product != null) {
              products.add(product);
            }
          }
          collection.products = products;
        }
      }

      // Sort collections by date
      collections.sort((a, b) {
        DateTime dateA = DateTime.parse(a.date!);
        DateTime dateB = DateTime.parse(b.date!);
        return dateB.compareTo(dateA); // For latest date first
      });

      return collections;
    } catch (e) {
      throw "Fetching collections for user id:$userId failed with error: ${e.toString()}";
    }
  }
}
