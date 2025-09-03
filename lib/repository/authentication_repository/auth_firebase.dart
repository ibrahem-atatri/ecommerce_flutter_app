import 'package:ecommerce_app/repository/authentication_repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthFirebase extends AuthRepository {
  @override
  Future<User?> registerUserAccount(email, password, name) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(name);
      await credential.user!.reload();
      return FirebaseAuth.instance.currentUser;
    } on FirebaseAuthException catch (e) {
      throw e; // Re-throw the exception to be handled by the UI or higher-level logic
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  @override
  Future<User?> signInUserToAccount(emailAddress, password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      await credential.user!.reload();
      return FirebaseAuth.instance.currentUser;
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  @override
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth == null) {
        return null; // User canceled sign-in
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw Exception('An unexpected error occurred during Google sign-in: $e');
    }
  }

  @override
  Future<User?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();
      if (loginResult.status == LoginStatus.success) {
        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(
              loginResult.accessToken!.tokenString,
            );

        // Once signed in, return the UserCredential
        final UserCredential userCardential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
        return userCardential.user;
      }
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw Exception(
        'An unexpected error occurred during Facebook sign-in: $e',
      );
    }
  }
}
