import 'package:flutter/material.dart';
import 'package:recycla_bin/features/profile/provider/user_provider.dart';
import '../data/models/rb_transaction_model.dart';
import '../data/repositories/rb_transaction_repository.dart';

class RBTransactionProvider with ChangeNotifier {
  final RBTransactionRepository _transactionRepository = RBTransactionRepository();

  Future<void> createTransaction({
    required IconData icon,
    required String title,
    required String details,
    required double amount,
    required RBTransactionType type,
    required RBTransactionStatus status,
    required UserProvider userProvider,
  }) async {
    try{
      final user = userProvider.user;
      if (user == null) {
        throw 'User in provider is null, please login again before you proceed.';
      }

      final oldAmount = double.tryParse(user.rbTokenz ?? '0') ?? 0;
      double newAmount;

      switch (type) {
        case RBTransactionType.TopUp:
          newAmount = oldAmount + amount;
          break;
        case RBTransactionType.PaidOut:
          newAmount = oldAmount - amount;
          break;
        case RBTransactionType.PaidIn:
        case RBTransactionType.Refund:
          newAmount = oldAmount + amount;
          break;
      }

      final transaction = RBTransactionModel(
        icon: icon,
        title: title,
        details: details,
        amount: amount,
        oldAmount: oldAmount,
        newAmount: newAmount,
        userId: user.id!,
        type: type,
        status: status,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _transactionRepository.createTransaction(transaction);

      // Update user's rbTokenz
      final updatedUser = user.copyWith(rbTokenz: newAmount.toString());
      await userProvider.updateUserDetails(user.id!, updatedUser);

      notifyListeners();
    }catch (e){
      rethrow;
    }
  }

  Future<void> updateTransaction(RBTransactionModel transaction) async {
    await _transactionRepository.updateTransaction(transaction);
    notifyListeners();
  }

  Future<List<RBTransactionModel>> fetchTransactionsByUserId(String userId) async {
    return await _transactionRepository.fetchTransactionsByUserId(userId);
  }
}
