import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl extends NetworkInfo {
  final InternetConnection _connectionChecker = InternetConnection();

  @override
  Future<bool> get isConnected async {
    bool isConnected = await _connectionChecker.hasInternetAccess;
    return isConnected;
  }
}
