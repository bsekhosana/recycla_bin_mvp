import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string/random_string.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import 'auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../data/models/user.dart' as custom_user;

class ForgotPasswordRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AuthRepository _authRepository = AuthRepository();

  // Future<String?> getUserByPhoneNumber(String phoneNumber) async {
  //   return await _authRepository.getUserByPhoneNumber(phoneNumber);
  // }


  // Future<firebase_auth.User?> getUserByPhoneNumber(String phoneNumber) async {
  //   return await _authRepository.getUserByPhoneNumber(phoneNumber);
  // }

  Future<custom_user.User?> getUserByPhoneNumber(String phoneNumber) async {
    return await _authRepository.getUserByPhoneNumber(phoneNumber);
  }


  // Future<String?> getUserByPhoneNumber(String phoneNumber) async {
  //   final querySnapshot = await _firestore
  //       .collection('users')
  //       .where('phoneNumber', isEqualTo: phoneNumber)
  //       .get();
  //
  //   if (querySnapshot.docs.isNotEmpty) {
  //     return querySnapshot.docs.first.id;
  //   }
  //   return null;
  // }

  Future<void> savePinForUser(String userId, String pin) async {
    await _firestore.collection('pins').doc(userId).set({'pin': pin});
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
      final documentSnapshot = await _firestore.collection('pins').doc(userId).get();
      if (documentSnapshot.exists && documentSnapshot['pin'] == pin) {
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
        'password': newPassword, // Ensure to hash the password if needed
      });
      print('password updated successfully');
      // firebase_auth.User? user = _firebaseAuth.currentUser;
      // if (user != null) {
      //   await user.updatePassword(newPassword);
      // } else {
      //   // Update password in Firestore for the custom user using the provided userId
      //
      // }
    } catch (e) {
      print('Error resetting password: $e');
      rethrow;
    }
  }
}
