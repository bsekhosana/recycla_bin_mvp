import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/core/services/connectivity_service.dart';

import '../../../core/utilities/error_handler.dart';
import '../../profile/provider/user_provider.dart';
import '../data/models/rb_user_model.dart';
import '../data/repositories/rb_auth_repository.dart';

class RBAuthProvider extends ChangeNotifier {
  final RBAuthRepository _authRepository = RBAuthRepository();
  final ConnectivityService _connectivityService = ConnectivityService();

  RBUserModel? _currentUser;

  RBUserModel? get currentUser => _currentUser;

  set currentUser(RBUserModel? user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<void> register({
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
    required String fullName,
    required BuildContext context,
  }) async {
    if (await _connectivityService.checkConnectivity()) {
      _currentUser = await _authRepository.registerUser(
        fullName: fullName,
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );
      // Fetch the newly registered user and update currentUser
      print('register context.mounted: ${context.mounted}');
      if(context.mounted){
        Provider.of<UserProvider>(context, listen: false).setUser(_currentUser);
      }
      notifyListeners();
    } else {
      // Handle no internet connection
      throw Exception("No internet connection");
    }
  }

  Future<void> login({required String email, required String password, required BuildContext context, bool shouldPersist = false}) async {
    if (await _connectivityService.checkConnectivity()) {
      _currentUser = await _authRepository.loginUser(email: email, password: password);
      print('login context.mounted: ${context.mounted}');
      if(context.mounted){
        Provider.of<UserProvider>(context, listen: false).setUser(_currentUser, shouldPersist: shouldPersist);
        print('login _currentUser: $_currentUser');
        print('is login persisted: $shouldPersist');
      }
      notifyListeners();
    } else {
      // Handle no internet connection
      throw Exception("No internet connection");
    }
  }

  Future<void> logout(BuildContext context) async {
    await _authRepository.signOut();
    _currentUser = null;
    if(context.mounted){
      Provider.of<UserProvider>(context, listen: false).clearUser();
    }
    notifyListeners();
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

  // Future<void> signInWithFacebook() async {
  //   if (await _connectivityService.checkConnectivity()) {
  //     try {
  //       await _authRepository.signInWithFacebook();
  //     } on FirebaseAuthException catch (e) {
  //       throw getFirebaseAuthErrorMessage(e);
  //     } catch (e) {
  //       print('An error occurred during Facebook sign-in. Error: ${e.toString()}');
  //       throw 'An error occurred during Facebook sign-in. Error: ${e.toString()}';
  //     }
  //   } else {
  //     throw 'No internet connection';
  //   }
  // }
  //
  // Future<void> signInWithApple() async {
  //   if (await _connectivityService.checkConnectivity()) {
  //     try {
  //       await _authRepository.signInWithApple();
  //     } on FirebaseAuthException catch (e) {
  //       throw getFirebaseAuthErrorMessage(e);
  //     } catch (e) {
  //       print('An error occurred during Apple sign-in. Error: ${e.toString()}');
  //       throw 'An error occurred during Apple sign-in. Error: ${e.toString()}';
  //     }
  //   } else {
  //     throw 'No internet connection';
  //   }
  // }
}
