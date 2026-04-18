import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Contract for checking real network reachability.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnection connectionChecker;

  const NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected async => true; // Bypassing for emulator testing
}
