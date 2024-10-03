// Function to handle different Dio errors and return meaningful messages
import 'package:dio/dio.dart';

String handleDioError(DioException error) {
  if (error.response != null) {
    // When we receive a response but it's an error (like 4xx/5xx)
    return handleHttpResponseError(error.response!);
  }

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return "Connection timeout. Please check your internet connection.";
    case DioExceptionType.sendTimeout:
      return "Send timeout in connection with the server.";
    case DioExceptionType.receiveTimeout:
      return "Receive timeout in connection with the server.";
    case DioExceptionType.cancel:
      return "Request to API server was cancelled.";
    case DioExceptionType.unknown:
      if (error.message?.contains("SocketException") == true) {
        return "No internet connection. Please check your connection.";
      }
      return "Something went wrong. Please try again.";
    default:
      return "Unexpected error occurred. Please try again.";
  }
}

// Handle different status codes from the server
String handleHttpResponseError(Response response) {
  final statusCode = response.statusCode;
  final responseData = response.data;

  // Handle 401 specifically (or any other status code)
  // if (statusCode == 401) {
  //   // Handle the custom message from the server's response
  //   if (responseData != null && responseData is Map<String, dynamic>) {
  //     final serverMessage = responseData['message'] ?? 'Unauthorized access';
  //     return "Error 401: $serverMessage";
  //   }
  //   return "Error 401: Unauthorized. Please log in.";
  // }

  switch (statusCode) {
    case 400:
      var serverMessage = (responseData as Map<String, dynamic>?)?['message'] ??
          'Bad request. Please check the data you sent.';
      return serverMessage;
    case 401:
      return "Unauthorized access";
    case 403:
      return "Forbidden. You don't have permission to access this resource.";
    case 404:
      return "Resource not found. Please check the URL.";
    case 500:
      return "Internal server error. Please try again later.";
    case 503:
      return "Service unavailable. Please try again later.";
    default:
      return "Received invalid status code: $statusCode.";
  }
}
