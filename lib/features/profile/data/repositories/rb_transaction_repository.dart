import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/services/firestore_repository_service.dart';
import '../models/rb_transaction_model.dart';

class RBTransactionRepository {
  final FirestoreRepository<RBTransactionModel> _firestoreRepository = FirestoreRepository(collectionPath: 'transactions');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> createTransaction(RBTransactionModel transaction) async {
    final docId = _firestore.collection('transactions').doc().id;
    transaction = transaction.copyWith(id: docId);
    await _firestoreRepository.createDocument(docId, transaction.toJson());
  }

  Future<RBTransactionModel?> getTransaction(String id) async {
    return await _firestoreRepository.readDocument(id, (data) => RBTransactionModel.fromJson(data));
  }

  Future<void> updateTransaction(RBTransactionModel transaction) async {
    if (transaction.id == null) return;
    await _firestoreRepository.updateDocument(transaction.id!, transaction.toJson());
  }

  Future<List<RBTransactionModel>> fetchTransactionsByUserId(String userId) async {
    try {
      return await _firestoreRepository.fetchAllDocumentsWithId('userId', userId, (data) => RBTransactionModel.fromJson(data));
    }catch (e){
      throw 'Failed to fetch transactions for user id: $userId with error: ${e.toString()}';
    }
  }
}
