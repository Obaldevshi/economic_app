import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService(this._connectivity);

  final Connectivity _connectivity;
  final StreamController<bool> _onlineController =
      StreamController<bool>.broadcast();
  bool _isOnline = true;

  bool get isOnline => _isOnline;
  Stream<bool> get onlineStream => _onlineController.stream;

  void init() {
    _connectivity.onConnectivityChanged.listen(_handleConnectivity);
    _connectivity.checkConnectivity().then(_handleConnectivity);
  }

  void _handleConnectivity(List<ConnectivityResult> results) {
    final online = results.any((result) => result != ConnectivityResult.none);
    if (_isOnline != online) {
      _isOnline = online;
      _onlineController.add(online);
    }
  }

  void dispose() {
    _onlineController.close();
  }
}
