import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recycla_bin/core/utilities/utils.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:crypto/crypto.dart';

import 'dart:convert';

import '../../../../core/utilities/error_handler.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/rb_user_model.dart';

class RBAuthRepository {

  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RBUserModel? _currentUser;

  RBUserModel? get currentUser => _currentUser;

  // Stream<firebase_auth.User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<RBUserModel?> getUserByPhoneNumber(String phoneNumber) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final userData = querySnapshot.docs.first.data();
      return RBUserModel.fromMap(userData);
    }
    return null;
  }

  Future<RBUserModel?> getUserByUid(String uid) async {
    final docSnapshot = await _firestore.collection('users').doc(uid).get();
    if (docSnapshot.exists) {
      final userData = docSnapshot.data();
      return RBUserModel.fromMap(userData!);
    }
    return null;
  }

  Future<String?> getUserIdByPhoneNumber(String phoneNumber) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    }
    return null;
  }

  Future<void> registerUser({required String username, required String email,required String password,required String phoneNumber, }) async {
    final String hashedPassword = Utils.hashString(password);

    final user = RBUserModel(
      id: _firestore.collection('users').doc().id,
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      hashedPassword: hashedPassword,
    );

    await _firestore.collection('users').doc(user.id).set(user.toJson());
  }

  Future<RBUserModel?> loginUser({required String email, required String password}) async {
    final String hashedPassword = Utils.hashString(password);
    try{
      final QuerySnapshot result = await _firestore.collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (result.docs.isEmpty) {
        throw getCustomAuthErrorMessage('user-not-found');
      } else {
        final foundUser =  RBUserModel.fromMap(result.docs.first.data() as Map<String, dynamic>);
        print('submitted hashedPassword: ${hashedPassword}');
        print('foundUser.hashedPassword: ${foundUser.hashedPassword}');
        if(foundUser.hashedPassword == hashedPassword){
          return RBUserModel.fromMap(result.docs.first.data() as Map<String, dynamic>);
        }else{
          throw getCustomAuthErrorMessage('invalid-credential');
        }

      }
    }catch(e){
      rethrow;
    }
  }

  Future<void> signOut() async {
    _currentUser = null;
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw getFirebaseAuthErrorMessage(e);
    }
  }

  // Future<void> signInWithFacebook() async {
  //   try {
  //
  //     print(FacebookAuth.instance);
  //     final LoginResult result = await FacebookAuth.instance.login();
  //     print('facebook login result: ${result}');
  //     if (result.status == LoginStatus.success) {
  //       final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
  //       await _firebaseAuth.signInWithCredential(credential);
  //     } else {
  //       print('facebook login result failed: ${result.status.toString()}');
  //       throw FirebaseAuthException(
  //         code: result.status.toString(),
  //         message: result.message,
  //       );
  //     }
  //     // final LoginResult result = await FacebookAuth.instance.login();
  //     // final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
  //     // await FirebaseAuth.instance.signInWithCredential(credential);
  //   } on FirebaseAuthException catch (e) {
  //     throw getFirebaseAuthErrorMessage(e);
  //   }
  // }
  //
  // Future<void> signInWithApple() async {
  //   try {
  //     final credential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
  //     );
  //     final oauthCredential = OAuthProvider("apple.com").credential(
  //       idToken: credential.identityToken,
  //       accessToken: credential.authorizationCode,
  //     );
  //     await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  //   } on FirebaseAuthException catch (e) {
  //     throw getFirebaseAuthErrorMessage(e);
  //   }
  // }
}
