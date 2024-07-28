import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../authentication/data/models/rb_user_model.dart';
import '../../authentication/provider/rb_auth_provider.dart';
import 'package:provider/provider.dart';

class UserProvider with ChangeNotifier {

  RBUserModel? _user;

  RBUserModel? get user => _user;

  void setUser(RBUserModel? user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
