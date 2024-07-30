import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> checkBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await _auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      print(e);
    }
    return authenticated;
  }

  Future<bool> isBiometricEnabled() async {
    try {
      return await _auth.isDeviceSupported();
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }
}
