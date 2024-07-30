

import 'package:recycla_bin/features/authentication/data/models/rb_user_model.dart';

import '../../../core/services/firestore_repository_service.dart';

class UserRepository{

  FirestoreRepository _firestoreRepository = FirestoreRepository(collectionPath: 'users');

  Future<void> updateUserDetails(String userId, RBUserModel user) async {
    try{
      print('saveUpdateUserDetails for user id: $userId');
      await _firestoreRepository.updateDocument(userId, user.toJson());
    }catch (e){
      throw e;
    }
  }

  Future<void> updateUserPassword(String userId, String newPassword) async {
    try{
      print('updateUserPassword for user id: $userId');
      await _firestoreRepository.updateDocumentField(userId, 'hashedPassword', newPassword);
    }catch (e){
      throw e;
    }
  }

}