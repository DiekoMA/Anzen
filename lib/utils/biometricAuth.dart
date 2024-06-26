import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuth {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<bool> authenticate() async {
    bool isAuthenticated = false;
    try {
      // Check if biometrics are available
      bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
      if (!canCheckBiometrics) {
        throw Exception('Biometrics are not available on this device.');
      }

      // Authenticate user with biometrics
      isAuthenticated = await _localAuthentication.authenticate(
        localizedReason: 'Authenticate to access your account.',
      );
    } catch (e) {
      print('Error authenticating: $e');
    }
    return isAuthenticated;
  }
}
