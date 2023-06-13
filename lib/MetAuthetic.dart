import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Authentic {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> loginFirebase(String email, String password) async {
    try {
      final UserCredential authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final User? user = authResult.user;
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<User?> loginGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {
      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User? user = authResult.user;
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<User?> loginFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
      final AuthCredential credential = FacebookAuthProvider.credential(accessToken.token);

      try {
        final UserCredential authResult = await _auth.signInWithCredential(credential);
        final User? user = authResult.user;
        return user;
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
    await FacebookAuth.instance.logOut();
  }
}
