import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart' as google_lib; // 1. Use Alias
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

// Provider to access this service
final googleAuthServiceProvider = Provider((ref) => GoogleAuthHelper());

// 2. RENAME CLASS to avoid conflict with the plugin
class GoogleAuthHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 3. Initialize using the alias
  final google_lib.GoogleSignIn _googleSignIn = google_lib.GoogleSignIn();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // A. Trigger the Google Authentication flow
      // using the alias to call the correct .signIn() method
      final google_lib.GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null;

      // B. Obtain the auth details
      final google_lib.GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // C. Create a new credential
      // NOTICE: accessToken might be nullable, handled safely here
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // D. Sign in to Firebase
      return await _auth.signInWithCredential(credential);

    } catch (e) {
      debugPrint("Error signing in with Google: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}