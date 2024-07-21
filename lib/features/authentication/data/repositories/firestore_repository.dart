import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRepository<T> {
  final String collectionPath;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirestoreRepository({required this.collectionPath});

  Future<void> createDocument(String id, Map<String, dynamic> data) async {
    await _firestore.collection(collectionPath).doc(id).set(data);
  }

  Future<T?> readDocument(String id, T Function(Map<String, dynamic> data) fromMap) async {
    DocumentSnapshot snapshot = await _firestore.collection(collectionPath).doc(id).get();
    if (snapshot.exists) {
      return fromMap(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateDocument(String id, Map<String, dynamic> data) async {
    await _firestore.collection(collectionPath).doc(id).update(data);
  }

  Future<void> deleteDocument(String id) async {
    await _firestore.collection(collectionPath).doc(id).delete();
  }
}
