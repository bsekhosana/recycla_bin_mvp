import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRepository<T> {
  final String collectionPath;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirestoreRepository({required this.collectionPath});

  Future<void> createDocument(String id, Map<String, dynamic> data) async {
    try{
      await _firestore.collection(collectionPath).doc(id).set(data);
    }catch (e){
      throw 'Failed to create document with error: ${e.toString()}';
    }

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

  Future<void> updateDocumentField(String id, String name, String value) async {
    await _firestore.collection(collectionPath).doc(id).update({name: value});
  }

  Future<void> deleteDocument(String id) async {
    await _firestore.collection(collectionPath).doc(id).delete();
  }

  Future<List<T>> fetchAllDocumentsWithId(String name, String value, T Function(Map<String, dynamic> data) fromMap) async {
    QuerySnapshot querySnapshot = await _firestore.collection(collectionPath).where(name, isEqualTo: value).get();
    return querySnapshot.docs.map((doc) {
      return fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }
}
