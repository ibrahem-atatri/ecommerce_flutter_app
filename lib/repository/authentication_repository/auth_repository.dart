import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/form.dart';
import 'package:flutter/src/widgets/framework.dart';

abstract class AuthRepository {
  Future<User?> registerUserAccount(String email, String password,String name) ;
  Future<User?> signInUserToAccount(String email,String password);
  Future<User?> signInWithGoogle ();
  Future<User?> signInWithFacebook ();

  // <UserCredential>

}