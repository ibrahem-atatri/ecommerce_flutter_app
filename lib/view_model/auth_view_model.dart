import 'dart:async';
import 'package:ecommerce_app/di/repository_provider.dart';
import 'package:ecommerce_app/repository/authentication_repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authStateProvider = StreamProvider<User?> ((ref) =>  FirebaseAuth.instance.authStateChanges(),);
final authViewModelProvider = StreamNotifierProvider<AuthViewModel,User?>(
  ( ) => AuthViewModel()
);

class AuthViewModel extends StreamNotifier<User?> {
  late final AuthRepository authRepository ;
  @override
  Stream<User?> build() {
        authRepository = ref.read(authRepositoryProvider);
    return FirebaseAuth.instance.authStateChanges();
  }

User? getCurrentUser()  {
    return FirebaseAuth.instance.currentUser;
}
  Future<void> register(GlobalKey<FormState> formKey,email, password, name) async {
    late final User? user;
    if(formKey.currentState!.validate()){
      state = AsyncValue.loading();
      try {
      user =  await authRepository.registerUserAccount(email, password, name);
      state = AsyncValue.data(user);
    } on FirebaseAuthException catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }}
  }
  Future<void> signInUserAccount(GlobalKey<FormState> formKey,email, password) async {
    late final User? user;
    if(formKey.currentState!.validate()){
      state = AsyncValue.loading();
      try {
          final user = await authRepository.signInUserToAccount(email, password);
        state = AsyncValue.data(user);
      } on FirebaseAuthException catch (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      } catch (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      }}
  }

  Future<void> signOutUser() async {
    state = AsyncValue.loading();
      try {
        final user = await FirebaseAuth.instance.signOut();
        final googleUser = await GoogleSignIn().signOut();
        final facebookUser = await FacebookAuth.instance.logOut();
        state = AsyncValue.data(null);
      } on FirebaseAuthException catch (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      } catch (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      }}

  Future<void> signInUsingGoogle() async {
    state = AsyncValue.loading();
    try {
      final user = await authRepository.signInWithGoogle();
      state = AsyncValue.data(user);
    } on FirebaseAuthException catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }}
  Future<void> signInUsingFacebook() async {
    state = AsyncValue.loading();
    try {
      final user = await authRepository.signInWithFacebook();
      state = AsyncValue.data(user);
    } on FirebaseAuthException catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }}



}
