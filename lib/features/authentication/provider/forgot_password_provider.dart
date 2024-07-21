import 'package:flutter/material.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/forgot_password_repository.dart';

class ForgotPasswordProvider with ChangeNotifier {
  final ForgotPasswordRepository _repository = ForgotPasswordRepository();
  final AuthRepository _authRepository = AuthRepository();

  Future<String?> getUserByPhoneNumber(String phoneNumber) async {
    return await _authRepository.getUserByPhoneNumber(phoneNumber);
  }

  Future<void> sendCode(String phoneNumber) async {
    try {
      print('sendCode to: $phoneNumber');
      final userId = await _repository.getUserByPhoneNumber(phoneNumber);
      if (userId != null) {
        final pin = await _repository.generatePin();
        await _repository.savePinForUser(userId, pin);
        await _repository.sendSMS(phoneNumber, pin);
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

  Future<void> resetPassword(String newPassword) async {
    await _repository.resetPassword(newPassword);
  }
}
