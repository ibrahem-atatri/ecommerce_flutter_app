class FirebaseAuthExceptionUtils{

  static String registerUsingEmailExceptionMapper(error){
    final message;
    switch (error.code) {
      case 'email-already-in-use':
        message = "This email address is already in use.";
        break;
      case 'invalid-email':
        message = "The email address is not valid.";
        break;
      case 'operation-not-allowed':
        message = "Email/password accounts are not enabled.";
        break;
      case 'weak-password':
        message = "The password is too weak.";
        break;
      default:
        message = "Registration error: ${error.message}";
    }
return message;
  }

  static String signInUsingEmailExceptionMapper(error){
    final message;
    switch (error.code) {
      case 'invalid-email':
        message = "The email address is not valid.";
        break;
      case 'user-disabled':
        message = "This user account has been disabled.";
        break;
      case 'user-not-found':
        message = "No account found with this email.";
        break;
      case 'wrong-password':
        message = "Incorrect password. Please try again.";
        break;
      case 'too-many-requests':
        message = "Too many failed attempts. Try again later.";
        break;
      default:
        message = "Login error: ${error.message}";
    }
    return message;
  }

  static signInUsingGoogleExceptionMapper(error){
    final message;
    switch (error.code) {
      case 'account-exists-with-different-credential':
        message = "This account exists with a different sign-in provider.";
        break;
      case 'invalid-credential':
        message = "Invalid Google credentials.";
        break;
      case 'operation-not-allowed':
        message = "Google sign-in is not enabled.";
        break;
      case 'user-disabled':
        message = "This account has been disabled.";
        break;
      case 'user-not-found':
        message = "No user found for this Google account.";
        break;
      case 'wrong-password':
        message = "Invalid password.";
        break;
      case 'too-many-requests':
        message = "Too many attempts. Try again later.";
        break;
      default:
        message = "Authentication error: ${error.message}";
    }
    return message;
  }

  static String signInUsingFacebookExceptionMapper(error){
    final message;
    switch (error.code) {
      case 'account-exists-with-different-credential':
        message = "An account already exists with different sign-in credentials.";
        break;
      case 'invalid-credential':
        message = "Invalid Facebook credentials.";
        break;
      case 'operation-not-allowed':
        message = "Facebook sign-in is not enabled.";
        break;
      case 'user-disabled':
        message = "This account has been disabled.";
        break;
      case 'user-not-found':
        message = "No user found for this Facebook account.";
        break;
      case 'wrong-password':
        message = "Invalid credentials.";
        break;
      case 'too-many-requests':
        message = "Too many attempts. Try again later.";
        break;
      default:
        message = "Authentication error: ${error.message}";
    }
    return message;
  }
}