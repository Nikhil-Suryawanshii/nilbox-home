import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

// 1. Provider to access this service
final appleAuthServiceProvider = Provider((ref) => AppleAuthService());

class AppleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider();

      // Request full scope to get email and name on first sign in
      appleProvider.addScope('email');
      appleProvider.addScope('name');

      // This works for both iOS (native UI) and Android (web-flow)
      return await _auth.signInWithProvider(appleProvider);

    } catch (e) {
      debugPrint("Error signing in with Apple: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}