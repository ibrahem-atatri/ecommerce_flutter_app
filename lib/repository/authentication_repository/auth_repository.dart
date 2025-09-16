import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User?> registerUserAccount({ email,  password,  name});
  Future<User?> signInUserToAccount({ email,  password});
  Future<User?> signInWithGoogle();
  Future<User?> signInWithFacebook();

  // <UserCredential>
}
