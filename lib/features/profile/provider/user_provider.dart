import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recycla_bin/core/utilities/utils.dart';
import 'package:recycla_bin/core/utilities/validators.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../core/utilities/error_handler.dart';
import '../../../core/utilities/shared_pref_util.dart';
import '../../authentication/data/models/rb_user_model.dart';
import '../../authentication/provider/rb_auth_provider.dart';
import 'package:provider/provider.dart';

import '../data/repositories/user_repository.dart';

class UserProvider with ChangeNotifier {

  final ConnectivityService _connectivityService = ConnectivityService();
  
  final UserRepository _userRepository = UserRepository();
  
  RBUserModel? _user;

  RBUserModel? get user => _user;

  UserProvider() {
    _loadUser();
  }

  void setUser(RBUserModel? user, {bool shouldPersist = false}) {
    _user = user;
    if(shouldPersist){
      _saveUser(user);
    }else{
      _saveUser(null);
    }
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    _saveUser(null);
    notifyListeners();
  }

  Future<void> updateUserDetails(String id, RBUserModel user) async {
    if (await _connectivityService.checkConnectivity()) {
      try{
        await _userRepository.updateUserDetails(id, user);
        setUser(user);
      }catch (e){
        throw 'Problem occurred updating user details: ${e.toString()}';
      }
    } else {
      // Handle no internet connection
      throw Exception("No internet connection");
    }
  }

  Future<void> updateUserPassword(String id, String newPassword, String oldHashedPassword) async {
    if (await _connectivityService.checkConnectivity()) {
      try{
        if(Validators.isPasswordValid(newPassword)){
          final String hashedPassword = Utils.hashString(newPassword);
          if(hashedPassword != oldHashedPassword){
            await _userRepository.updateUserPassword(id, hashedPassword);
            // Update the user in provider after successful password update
            if (_user != null) {
              setUser(_user!.copyWith(hashedPassword: hashedPassword));
            }
          }else{
            throw getCustomAuthErrorMessage('same-password');
          }
        }else{
          throw getCustomAuthErrorMessage('weak-password');
        }

      }catch (e){
        throw e;
      }
    } else {
      // Handle no internet connection
      throw Exception("No internet connection");
    }
  }

  Future<void> _loadUser() async {
    _user = await SharedPrefUtil().get<RBUserModel>('user', fromJson: (json) => RBUserModel.fromJson(json));
    notifyListeners();
  }

  Future<void> _saveUser(RBUserModel? user) async {
    if (user != null) {
      await SharedPrefUtil().save('user', user.toJson());
    } else {
      await SharedPrefUtil().remove('user');
    }
  }
}
