import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../network/network_info.dart';
import 'package:ecommerce_app/core/cubits/base_cubit.dart';

enum NetworkStatus { connected, disconnected }

class NetworkState {
  final NetworkStatus status;
  const NetworkState(this.status);
}

class NetworkCubit extends BaseCubit<NetworkState> {
  final NetworkInfo _networkInfo;
  StreamSubscription? _subscription;

  NetworkCubit(this._networkInfo) : super(const NetworkState(NetworkStatus.connected)) {
    _monitorConnection();
  }

  void _monitorConnection() {
    _subscription = _networkInfo.onStatusChange.listen((status) {
      if (status == InternetStatus.connected) {
        emit(const NetworkState(NetworkStatus.connected));
      } else {
        emit(const NetworkState(NetworkStatus.disconnected));
      }
    });
  }

  Future<void> checkConnection() async {
    final isConnected = await _networkInfo.isConnected;
    emit(NetworkState(
      isConnected ? NetworkStatus.connected : NetworkStatus.disconnected,
    ));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
