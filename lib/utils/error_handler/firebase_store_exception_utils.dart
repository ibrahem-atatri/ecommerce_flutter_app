class FirebaseStoreExceptionUtils{
  static String firestoreExceptionMapper(error){
      final message;
      switch (error.code) {
        case 'permission-denied':
          message = "You don’t have permission to perform this action.";
        case 'unauthenticated':
          message = "You must sign in first.";
        case 'invalid-argument':
          message = "Invalid data provided.";
        case 'not-found':
          message = "The requested item was not found.";
        case 'already-exists':
          message = "This item already exists.";
        case 'unavailable':
          message = "Service is temporarily unavailable. Try again later.";
        case 'cancelled':
          message = "Operation was cancelled.";
        case 'deadline-exceeded':
          message = "Request timed out. Try again.";
        case 'aborted':
          message = "Operation aborted due to concurrency issue.";
        case 'failed-precondition':
          message = "Operation cannot be performed at this time.";
        case 'out-of-range':
          message = "Requested data is out of range.";
        case 'unimplemented':
          message = "This operation is not supported.";
        case 'internal':
          message = "Internal server error. Try again later.";
        case 'data-loss':
          message = "Unrecoverable data loss occurred.";
        case 'unknown':
          message = "Unknown error occurred.";
        default:
          return "Firestore error: ${error.message}";
      }

    return message;

  }
}