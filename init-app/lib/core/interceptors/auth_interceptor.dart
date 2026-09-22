import 'package:mobile_template/core/network/auth_api_paths.dart';
import 'package:mobile_template/core/services/session_service.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._sessionService);

  final SessionService _sessionService;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!AuthApiPaths.isUnauthenticated(options.path)) {
      final authHeader = _sessionService.getAuthHeader();
      if (authHeader != null) {
        options.headers['Authorization'] = authHeader;
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        !AuthApiPaths.isUnauthenticated(err.requestOptions.path)) {
      await _sessionService.clearSession();
    }
    handler.next(err);
  }
}
