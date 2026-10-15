import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService(this._connectivity);

  final Connectivity _connectivity;
  final StreamController<bool> _onlineController =
      StreamController<bool>.broadcast();
  bool _isOnline = true;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Timer? _offlineDelay;

  bool get isOnline => _isOnline;
  Stream<bool> get onlineStream => _onlineController.stream;

  void init() {
    _subscription = _connectivity.onConnectivityChanged.listen(
      _handleConnectivity,
    );
    _connectivity
        .checkConnectivity()
        .then(_handleConnectivity)
        .catchError((Object _) {});
  }

  void _handleConnectivity(List<ConnectivityResult> results) {
    final online = results.any((result) => result != ConnectivityResult.none);
    _offlineDelay?.cancel();
    if (!online) {
      _offlineDelay = Timer(const Duration(seconds: 2), () => _publish(false));
    } else {
      _publish(true);
    }
  }

  void _publish(bool online) {
    if (_isOnline != online) {
      _isOnline = online;
      _onlineController.add(online);
    }
  }

  void dispose() {
    _subscription?.cancel();
    _offlineDelay?.cancel();
    _onlineController.close();
  }
}
