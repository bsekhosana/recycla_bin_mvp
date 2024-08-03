import 'package:cloud_firestore/cloud_firestore.dart';

import '../data_provider/shared_pref_provider.dart';
import '../models/rb_collection.dart';

class RBCollectionRepository {
  final SharedPrefProvider sharedPrefProvider;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RBCollectionRepository({required this.sharedPrefProvider});

  Future<void> saveCollection(RBCollection collection) {
    return sharedPrefProvider.saveRBCollection(collection);
  }

  Future<RBCollection?> getCollection() {
    return sharedPrefProvider.getRBCollection();
  }

  Future<void> removeCollection() {
    return sharedPrefProvider.removeRBCollection();
  }

  Future<void> saveCollectionToFirestore(RBCollection collection, String userId) async {
    if (collection == null) return;
    try{
      final collectionDoc = _firestore.collection('collections').doc();
      final batch = _firestore.batch();

      // Update the collection instance with the document ID
      final collectionId = collectionDoc.id;
      print('new collection id: ${collectionId}');
      collection = collection.copyWith(id: collectionId);

      final products = collection!.products!;
      for (final product in products) {
        final productDoc = _firestore.collection('products').doc(product.id);
        final productSnapshot = await productDoc.get();
        if (!productSnapshot.exists) {
          batch.set(productDoc, product.toJson());
        }
      }

      final collectionData = collection!.toJson();
      collectionData['userId'] = userId; // Link collection to user
      collectionData['products'] = products.map((p) => p.id).toList();
      batch.set(collectionDoc, collectionData);

      await batch.commit();
    }catch (e){
      throw 'Save collection to firestore failed with error: ${e.toString()}';
    }
  }
}
