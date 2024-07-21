import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recycla_bin/core/services/connectivity_service.dart';

import '../../../core/utilities/error_handler.dart';
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

  Future<void> signInWithGoogle() async {
    if (await _connectivityService.checkConnectivity()) {
      try {
        await _authRepository.signInWithGoogle();
      } on FirebaseAuthException catch (e) {
        throw getFirebaseAuthErrorMessage(e);
      } catch (e) {
        print('An error occurred during Google sign-in. Error: ${e.toString()}');
        throw 'An error occurred during Google sign-in. Error: ${e.toString()}';
      }
    } else {
      throw 'No internet connection';
    }
  }

  Future<void> signInWithFacebook() async {
    if (await _connectivityService.checkConnectivity()) {
      try {
        await _authRepository.signInWithFacebook();
      } on FirebaseAuthException catch (e) {
        throw getFirebaseAuthErrorMessage(e);
      } catch (e) {
        print('An error occurred during Facebook sign-in. Error: ${e.toString()}');
        throw 'An error occurred during Facebook sign-in. Error: ${e.toString()}';
      }
    } else {
      throw 'No internet connection';
    }
  }

  Future<void> signInWithApple() async {
    if (await _connectivityService.checkConnectivity()) {
      try {
        await _authRepository.signInWithApple();
      } on FirebaseAuthException catch (e) {
        throw getFirebaseAuthErrorMessage(e);
      } catch (e) {
        print('An error occurred during Apple sign-in. Error: ${e.toString()}');
        throw 'An error occurred during Apple sign-in. Error: ${e.toString()}';
      }
    } else {
      throw 'No internet connection';
    }
  }
}
