import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:http/http.dart' as http;
import 'package:recycla_bin/core/utilities/utils.dart';
import '../models/rb_user_model.dart';
import 'rb_auth_repository.dart';

class ForgotPasswordRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RBAuthRepository _authRepository = RBAuthRepository();

  Future<RBUserModel?> getUserByPhoneNumber(String phoneNumber) async {
    return await _authRepository.getUserByPhoneNumber(phoneNumber);
  }

  Future<void> savePinForUser(String userId, String pin) async {
    print('save pin: $pin for user id: $userId');
    await _firestore.collection('users').doc(userId).update({'hashedPin': Utils.hashString(pin)});
  }

  Future<void> sendSMS(String phoneNumber, String pin) async {
    final response = await http.post(
      Uri.parse('https://rest.nexmo.com/sms/json'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'api_key': '996c193a',
        'api_secret': 'yiXR9agoSIcfe7Kt',
        'to': phoneNumber,
        'from': 'Recycla Bin',
        'text': 'Your verification code is: $pin',
      },
    );

    if (response.statusCode == 200) {
      print('SMS sent successfully');
    } else {
      print('Failed to send SMS');
    }
  }

  Future<String> generatePin() async {
    return randomNumeric(6);
  }

  Future<bool> verifyPin(String userId, String pin) async {
    try {
      final documentSnapshot = await _firestore.collection('users').doc(userId).get();
      if (documentSnapshot.exists && documentSnapshot['hashedPin'] == Utils.hashString(pin)) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error verifying pin: $e');
      return false;
    }
  }

  Future<void> resetPassword(String newPassword, String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'hashedPassword': Utils.hashString(newPassword), // Ensure to hash the password if needed
      });
      print('password updated successfully');
    } catch (e) {
      print('Error resetting password: $e');
      rethrow;
    }
  }
}
