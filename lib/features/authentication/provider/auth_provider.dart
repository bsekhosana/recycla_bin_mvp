import 'package:flutter/material.dart';
import 'package:recycla_bin/core/services/connectivity_service.dart';

import '../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final ConnectivityService _connectivityService = ConnectivityService();

  Future<void> register({
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    if (await _connectivityService.checkConnectivity()) {
      await _authRepository.register(
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );
      notifyListeners();
    } else {
      // Handle no internet connection
      throw Exception("No internet connection");
    }
  }

  Future<void> login({required String email, required String password}) async {
    if (await _connectivityService.checkConnectivity()) {
      await _authRepository.login(email: email, password: password);
      notifyListeners();
    } else {
      // Handle no internet connection
      throw Exception("No internet connection");
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}
