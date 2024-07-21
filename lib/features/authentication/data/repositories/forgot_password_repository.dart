import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getUserByPhoneNumber(String phoneNumber) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    }
    return null;
  }

  Future<void> savePinForUser(String userId, String pin) async {
    await _firestore.collection('pins').doc(userId).set({'pin': pin});
  }

  Future<void> sendSMS(String phoneNumber, String pin) async {
    // Use a free SMS service API, example using Textbelt
    // final response = await http.post(
    //   Uri.parse('https://textbelt.com/text'),
    //   body: {
    //     'phone': phoneNumber,
    //     'message': 'Your verification code is: $pin',
    //     'key': 'textbelt'
    //   },
    // );

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
}
