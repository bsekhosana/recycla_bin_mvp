import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/core/constants/shared_preferences_keys.dart';
import 'package:recycla_bin/features/authentication/provider/rb_auth_provider.dart';
import '../../../core/utilities/shared_pref_util.dart';
import '../data/repositories/rb_auth_repository.dart';
import '../data/repositories/forgot_password_repository.dart';

import 'package:recycla_bin/features/authentication/provider/rb_auth_provider.dart' as custom_provider;

import '../data/models/rb_user_model.dart' as custom_user;

class ForgotPasswordProvider with ChangeNotifier {
  final ForgotPasswordRepository _repository = ForgotPasswordRepository();
  final RBAuthRepository _authRepository = RBAuthRepository();
  final RBAuthProvider _authProvider = RBAuthProvider();
  final SharedPrefUtil _sharedPrefUtil = SharedPrefUtil();

  Future<String?> getUserIdByPhoneNumber(String phoneNumber) async {
    return await _authRepository.getUserIdByPhoneNumber(phoneNumber);
  }

  Future<void> sendCode(String phoneNumber, BuildContext context) async {
    try {
      print('sendCode to: $phoneNumber');
      final user = await _repository.getUserByPhoneNumber(phoneNumber);
      if (user != null) {
        final pin = await _repository.generatePin();
        await _repository.savePinForUser(user.id!, pin);
        await _repository.sendSMS(phoneNumber, pin);

        _sharedPrefUtil.save(AppSharedKeys.userIdKey, user.id);
        _sharedPrefUtil.save(AppSharedKeys.userEmailKey, user.email);
        print('saved user email: ${user.email} and  id: ${user.id}');
        print('setting user:${user}');
        _authProvider.currentUser = user;
        print('auth provider user:${_authProvider.currentUser}');

        notifyListeners();
      } else {
        throw Exception('Phone number not found');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> verifyPin(String userId, String pin) async {
    return await _repository.verifyPin(userId, pin);
  }

  Future<void> resetPassword(String newPassword, String userId) async {
    try{
      await _repository.resetPassword(newPassword, userId);
    }catch(e) {
      rethrow;
    }
  }
}
