import 'package:cloud_firestore/cloud_firestore.dart';

import '../data_provider/shared_pref_provider.dart';
import '../models/rb_collection.dart';
import '../models/rb_collection_product.dart';
import '../models/rb_product.dart';

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

  Future<RBCollection> saveCollectionToFirestore(RBCollection collection, String userId) async {
    try {
      final collectionDoc = _firestore.collection('collections').doc();
      final batch = _firestore.batch();

      // Update the collection instance with the document ID
      final collectionId = collectionDoc.id;
      print('new collection id: $collectionId');
      collection = collection.copyWith(id: collectionId);

      // Convert collectionProducts to a JSON-compatible format
      final collectionProducts = collection.collectionProducts!;
      List<Map<String, dynamic>> serializedCollectionProducts = collectionProducts.map((cp) => cp.toJson()).toList();
      print('new collection serializedCollectionProducts: $serializedCollectionProducts');
      // Prepare collection data with the collectionProducts included
      final collectionData = collection.toJson();
      collectionData['userId'] = userId; // Link collection to user
      collectionData['collectionProducts'] = serializedCollectionProducts; // Embed serialized collectionProducts

      // Save the collection document with all related products
      batch.set(collectionDoc, collectionData);

      // Commit the batch operation
      await batch.commit();

      return collection; // Return the updated collection with the new ID

    } catch (e) {
      print('Save collection to firestore failed with error: ${e.toString()}');
      throw 'Save collection to firestore failed with error: ${e.toString()}';
    }
  }

}
