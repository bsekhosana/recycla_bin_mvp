import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> checkConnectivity() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    bool connected = connectivityResult != ConnectivityResult.none;
    print('Connected: $connected');
    return connectivityResult != ConnectivityResult.none;
  }
}
