import 'package:flutter/material.dart';
import '../data/repositories/forgot_password_repository.dart';

class ForgotPasswordProvider with ChangeNotifier {
  final ForgotPasswordRepository _repository = ForgotPasswordRepository();

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
}
