import 'package:firebase_auth/firebase_auth.dart';

String getFirebaseAuthErrorMessage(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return 'The email address is not valid.';
    case 'user-disabled':
      return 'The user corresponding to the given email has been disabled.';
    case 'user-not-found':
      return 'There is no user corresponding to the given email.';
    case 'wrong-password':
      return 'The password is invalid for the given email, or the account does not have a password.';
    case 'email-already-in-use':
      return 'The email address is already in use by another account.';
    case 'operation-not-allowed':
      return 'Email/password accounts are not enabled. Enable email/password accounts in the Firebase Console, under the Auth tab.';
    case 'weak-password':
      return 'The password is too weak. Passwords must be at least 6 characters long, and should include a mix of upper and lower case letters, numbers, and special characters.';
    case 'invalid-credential':
    case 'credential-too-old':
      return 'The supplied login credentials are incorrect, malformed, or have expired.';
    default:
      return 'An unknown error occurred. Please try again later. (Error code: ${e.code})';
  }
}

String getCustomAuthErrorMessage(String code){
  switch (code) {
    case 'invalid-email':
      return 'The email address is not valid.';
    case 'user-disabled':
      return 'The user corresponding to the given email has been disabled.';
    case 'user-not-found':
      return 'There is no user corresponding to the given email.';
    case 'wrong-password':
      return 'The password is invalid for the given email, or the account does not have a password.';
    case 'email-already-in-use':
      return 'The email address is already in use by another account.';
    case 'username-already-in-use':
      return 'The username is already in use by another account.';
    case 'phone-number-already-in-use':
      return 'The phone number is already in use by another account.';
    case 'operation-not-allowed':
      return 'Email/password accounts are not enabled. Enable email/password accounts in the Firebase Console, under the Auth tab.';
    case 'weak-password':
      return 'The password is too weak. Passwords must be at least 6 characters long, and should include a mix of upper and lower case letters, numbers, and special characters.';
    case 'same-password':
      return 'Submitted password cannot be the same as current password, please enter different password.';
    case 'invalid-credential':
    case 'credential-too-old':
      return 'The supplied login credentials are incorrect, malformed, or have expired.';
    default:
      return 'An unknown error occurred. Please try again later. (Error code: ${code})';
  }
}
