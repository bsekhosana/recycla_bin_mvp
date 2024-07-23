import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../core/utilities/error_handler.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../data/models/user.dart' as custom_user;

class AuthRepository {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuth get firebaseAuth => _firebaseAuth;

  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;

  Stream<firebase_auth.User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<custom_user.User?> getUserByPhoneNumber(String phoneNumber) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final userData = querySnapshot.docs.first.data();
      return custom_user.User.fromMap(userData, querySnapshot.docs.first.id);
    }
    return null;
  }

  Future<custom_user.User?> getUserByUid(String uid) async {
    final docSnapshot = await _firestore.collection('users').doc(uid).get();
    if (docSnapshot.exists) {
      final userData = docSnapshot.data();
      return custom_user.User.fromMap(userData!, docSnapshot.id);
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

  Future<void> register({
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
          'phoneNumber': phoneNumber,
        });
      }
    } on FirebaseAuthException catch (e) {
      throw getFirebaseAuthErrorMessage(e);
    } catch (e) {
      throw 'An error occurred during registration.';
    }
  }

  Future<User?> login({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw getFirebaseAuthErrorMessage(e);
    } catch (e) {
      throw 'An error occurred during login.';
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
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

  Future<void> signInWithFacebook() async {
    try {

      print(FacebookAuth.instance);
      final LoginResult result = await FacebookAuth.instance.login();
      print('facebook login result: ${result}');
      if (result.status == LoginStatus.success) {
        final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
        await _firebaseAuth.signInWithCredential(credential);
      } else {
        print('facebook login result failed: ${result.status.toString()}');
        throw FirebaseAuthException(
          code: result.status.toString(),
          message: result.message,
        );
      }
      // final LoginResult result = await FacebookAuth.instance.login();
      // final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
      // await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw getFirebaseAuthErrorMessage(e);
    }
  }

  Future<void> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } on FirebaseAuthException catch (e) {
      throw getFirebaseAuthErrorMessage(e);
    }
  }
}
