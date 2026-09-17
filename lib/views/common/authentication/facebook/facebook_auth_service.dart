import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final facebookAuthServiceProvider = Provider<FacebookAuthService>((ref) {
  return FacebookAuthService();
});

class FacebookAuthException implements Exception {
  final String message;
  FacebookAuthException(this.message);

  @override
  String toString() => message;
}

class FacebookAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.cancelled) {
        return null;
      }

      if (result.status != LoginStatus.success || result.accessToken == null) {
        throw FacebookAuthException(
          result.message ??
              'Facebook sign-in failed. Enable Facebook login in Firebase and check the Facebook app setup.',
        );
      }

      final OAuthCredential credential = FacebookAuthProvider.credential(
        result.accessToken!.tokenString,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } on FacebookAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Facebook Sign-In error: ${e.code} ${e.message}');
      if (e.code == 'operation-not-allowed') {
        throw FacebookAuthException(
          'Facebook sign-in is not enabled in Firebase Authentication.',
        );
      }
      throw FacebookAuthException(
        e.message ?? 'Facebook sign-in failed. Please try again.',
      );
    } catch (e) {
      debugPrint('Error signing in with Facebook: $e');
      throw FacebookAuthException('Facebook sign-in failed. Please try again.');
    }
  }

  Future<void> logout() async {
    try {
      await FacebookAuth.instance.logOut();
    } catch (e) {
      debugPrint('Facebook logout error: $e');
    }
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      debugPrint('Firebase signOut error: $e');
    }
  }
}
