import 'dart:async';
import 'dart:io';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Contract for checking real network reachability.
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<InternetStatus> get onStatusChange;
}

class NetworkInfoImpl implements NetworkInfo {
  const NetworkInfoImpl();

  @override
  Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  @override
  Stream<InternetStatus> get onStatusChange async* {
    bool previousState = true;
    yield InternetStatus.connected; // Assume connected initially
    
    while (true) {
      await Future.delayed(const Duration(seconds: 3));
      final currentState = await isConnected;
      if (currentState != previousState) {
        previousState = currentState;
        yield currentState ? InternetStatus.connected : InternetStatus.disconnected;
      }
    }
  }
}
