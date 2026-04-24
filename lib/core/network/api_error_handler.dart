import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../errors/exceptions.dart';

class ApiErrorHandler {
  static Never handle(Object e) {
    if (e is SocketException || e.toString().contains('SocketException') || e.toString().contains('Failed host lookup')) {
      throw const NetworkException();
    } else if (e is PostgrestException) {
      throw ServerException(e.message);
    } else if (e is AuthException) {
      throw ServerException(e.message);
    } else if (e is ServerException || e is NetworkException) {
      throw e; // rethrow already handled exceptions
    } else {
      throw ServerException(e.toString());
    }
  }
}
