import 'dart:async';
import 'package:ecommerce_app/di/repository_provider.dart';
import 'package:ecommerce_app/repository/authentication_repository/auth_repository.dart';
import 'package:ecommerce_app/ui/cart_item/cart_item_view_model.dart';
import 'package:ecommerce_app/utils/error_handler/firebase_auth_exception_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

final logInRegisterViewModelProvider = AsyncNotifierProvider<LogInRegisterViewModel, User?>(
  () => LogInRegisterViewModel(),
);

class LogInRegisterViewModel extends AsyncNotifier<User?> {
  AuthRepository get authRepository => ref.read(authRepositoryProvider);
  @override
  FutureOr<User?> build() {
    return FirebaseAuth.instance.currentUser;
  }

  User? get getCurrentUser => FirebaseAuth.instance.currentUser;
  // Register using email and password
  Future<void> register({
    required email,
    required password,
    required name,
  }) async {
    late final User? user;
    state = AsyncValue.loading();
    try {
      user = await authRepository.registerUserAccount(
        email: email,
        password: password,
        name: name,
      );
      state = AsyncValue.data(user);
      ref.read(cartItemViewProvider.notifier).refershCartItem();
    } on FirebaseAuthException catch (error, stackTrace) {
      state = AsyncValue.error(
        FirebaseAuthExceptionUtils.registerUsingEmailExceptionMapper(error),
        stackTrace,
      );
    } catch (error, stackTrace) {
      final String message;
      message = error.toString();
      state = AsyncValue.error(message, stackTrace);
    }
  }

  // sign in to exist email
  Future<void> signInUserAccount({required email, required password}) async {
    state = AsyncValue.loading();
    try {
      final user = await authRepository.signInUserToAccount(
        email: email,
        password: password,
      );
      state = AsyncValue.data(user);
      ref.read(cartItemViewProvider.notifier).refershCartItem();
    } on FirebaseAuthException catch (error, stackTrace) {
      state = AsyncValue.error(
        FirebaseAuthExceptionUtils.signInUsingEmailExceptionMapper(error),
        stackTrace,
      );
    } catch (error, stackTrace) {
      final message = error.toString();
      state = AsyncValue.error(message, stackTrace);
    }
  }

  Future<void> signInUsingGoogle() async {
    state = AsyncValue.loading();
    try {
      final user = await authRepository.signInWithGoogle();
      state = AsyncValue.data(user);
      ref.read(cartItemViewProvider.notifier).refershCartItem();
    } on FirebaseAuthException catch (error, stackTrace) {
      state = AsyncValue.error(
        FirebaseAuthExceptionUtils.signInUsingGoogleExceptionMapper(error),
        stackTrace,
      );
    } catch (error, stackTrace) {
      final message = error.toString();
      state = AsyncValue.error(message, stackTrace);
    }
  }

  Future<void> signInUsingFacebook() async {
    state = AsyncValue.loading();
    try {
      final user = await authRepository.signInWithFacebook();
      state = AsyncValue.data(user);
      ref.read(cartItemViewProvider.notifier).refershCartItem();
    } on FirebaseAuthException catch (error, stackTrace) {
      state = AsyncValue.error(
        FirebaseAuthExceptionUtils.signInUsingFacebookExceptionMapper(error),
        stackTrace,
      );
    } catch (error, stackTrace) {
      final message = error.toString();
      state = AsyncValue.error(message, stackTrace);
    }
  }

  Future<void> signOutUser() async {
    state = AsyncValue.loading();
    try {
      final user = await FirebaseAuth.instance.signOut();
      final googleUser = await GoogleSignIn().signOut();
      final facebookUser = await FacebookAuth.instance.logOut();

      state = AsyncValue.data(null);
    } on FirebaseAuthException catch (error, stackTrace) {
      state = AsyncValue.error(error.toString(), stackTrace);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error.toString(), stackTrace);
    }
  }
}
