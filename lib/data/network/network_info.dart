import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl extends NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  Future<bool> get isConnected async {
    var result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
