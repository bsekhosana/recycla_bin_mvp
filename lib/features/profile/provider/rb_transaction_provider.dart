import 'package:flutter/material.dart';
import 'package:recycla_bin/features/profile/provider/user_provider.dart';
import '../../../core/services/connectivity_service.dart';
import '../data/models/rb_transaction_model.dart';
import '../data/repositories/rb_transaction_repository.dart';

class RBTransactionProvider with ChangeNotifier {

  final ConnectivityService _connectivityService = ConnectivityService();

  final RBTransactionRepository _transactionRepository = RBTransactionRepository();

  List<RBTransactionModel> _transactions = [];

  List<RBTransactionModel> get transactions => _transactions;

  // Add this getter to return the number of transactions
  int get transactionCount => _transactions.length;

  Future<RBTransactionModel> createTransaction({
    required IconData icon,
    required String title,
    required String details,
    required double amount,
    required RBTransactionType type,
    required RBTransactionStatus status,
    required UserProvider userProvider,
  }) async {
    if (await _connectivityService.checkConnectivity()) {
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

        addTransaction(transaction);

        notifyListeners();

        return transaction;
      }catch (e){
        rethrow;
      }
    } else {
      // Handle no internet connection
      throw Exception("No internet connection");
    }
  }

  void addTransaction(RBTransactionModel transaction) {
    _transactions.add(transaction);
    _transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  Future<void> updateTransaction(RBTransactionModel transaction) async {
    if (await _connectivityService.checkConnectivity()) {
      await _transactionRepository.updateTransaction(transaction);
      notifyListeners();
    } else {
      // Handle no internet connection
      throw Exception("No internet connection");
    }
  }

  Future<void> fetchTransactionsByUserId(String userId) async {
    if (await _connectivityService.checkConnectivity()) {
      try {
        _transactions = await _transactionRepository.fetchTransactionsByUserId(userId);
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    } else {
      // Handle no internet connection
      throw Exception("No internet connection");
    }
  }
}
