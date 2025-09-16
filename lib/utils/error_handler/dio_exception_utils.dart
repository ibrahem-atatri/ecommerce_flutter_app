import 'package:dio/dio.dart';

class DioExceptionUtils {
  static String DioExceptionMapper(error){
    String message;
    switch (error.type) {
      case DioExceptionType.cancel:
        message = "Request was cancelled.";
        break;
      case DioExceptionType.connectionTimeout:
        message = "Connection timeout. Please try again.";
        break;
      case DioExceptionType.sendTimeout:
        message = "Send timeout. Please try again.";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Receive timeout. Please try again.";
        break;
      case DioExceptionType.badCertificate:
        message = "Invalid SSL certificate.";
        break;
      case DioExceptionType.connectionError:
        message = "No internet connection. Please check your network.";
        break;
      case DioExceptionType.badResponse:
      // Handle HTTP error status codes
        final statusCode = error.response?.statusCode;
        switch (statusCode) {
          case 400:
            message = "Bad request. Please check your input.";
            break;
          case 401:
            message = "Unauthorized. Please log in again.";
            break;
          case 403:
            message = "Forbidden request.";
            break;
          case 404:
            message = "Not found.";
            break;
          case 500:
            message = "Internal server error. Please try later.";
            break;
          default:
            message = "Server error ($statusCode): ${error.response?.statusMessage}";
        }
        break;
      case DioExceptionType.unknown:
      default:
        message = "Unexpected error: ${error.message}";
        break;
    }
    return message;
  }
}