import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final facebookAuthServiceProvider = Provider<FacebookAuthService>((ref) {
  return FacebookAuthService();
});

class FacebookAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Sign in with Facebook and return Firebase UserCredential
  Future<UserCredential?> signInWithFacebook() async {
    // Trigger Facebook Login
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile'],
    );

    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;

      // // Create Firebase credential
      // final OAuthCredential credential =
      // FacebookAuthProvider.credential(accessToken.token);
      // Create Firebase credential
      final OAuthCredential credential =
      FacebookAuthProvider.credential(accessToken.tokenString);


      // Sign in to Firebase
      return await _firebaseAuth.signInWithCredential(credential);
    }

    // User cancelled or error
    return null;
  }

  Future<void> logout() async {
    await FacebookAuth.instance.logOut();
    await _firebaseAuth.signOut();
  }
}
