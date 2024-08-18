import 'package:recycla_bin/core/services/firestore_repository_service.dart';
import '../models/rb_collection.dart';
import '../models/rb_product.dart';
import '../models/rb_collection_product.dart';

class RBCollectionsRepository {
  final FirestoreRepository _firestoreRepository = FirestoreRepository(collectionPath: 'collections');
  final FirestoreRepository _productRepository = FirestoreRepository(collectionPath: 'products');

  Future<List<RBCollection>> fetchCollections(String userId) async {
    try {
      List<RBCollection> collections = await _firestoreRepository.fetchAllDocumentsWithId(
        'userId',
        userId,
            (data) {
          return RBCollection.fromJson(data);
        },
      ).then((value) => value.cast<RBCollection>());

      for (var collection in collections) {
        if (collection.collectionProducts != null) {
          List<RBProduct> products = [];
          for (var collectionProduct in collection.collectionProducts!) {
            var product = await _productRepository.readDocument(
              collectionProduct.productId!,
                  (prodData) => RBProduct.fromJson(prodData),
            );
            if (product != null) {
              product.quantity = collectionProduct.quantity; // Set the quantity from RBCollectionProduct
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
