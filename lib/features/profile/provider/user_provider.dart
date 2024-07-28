import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../features/authentication/data/models/rb_user_model.dart' as local_user;
import '../../authentication/data/models/rb_user_model.dart';

class UserProvider with ChangeNotifier {
  firebase_auth.User? _firebaseUser;
  RBUserModel? _user;
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  firebase_auth.User? get firebaseUser => _firebaseUser;
  RBUserModel? get user => _user;

  Future<void> _onAuthStateChanged(firebase_auth.User? firebaseUser) async {
    _firebaseUser = firebaseUser;
    if (firebaseUser != null) {
      await _fetchUserData(firebaseUser.uid);
    } else {
      _user = null;
    }
    notifyListeners();
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        _user = RBUserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      } else {
        _user = null;
      }
    } catch (e) {
      print(e);
      _user = null;
    }
  }

  Future<void> signInWithEmailPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
