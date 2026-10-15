/// Retrofit auth endpoint paths (relative to API base URL).
abstract final class AuthApiPaths {
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const passwordResetRequest = '/auth/password-reset/request';
  static const passwordResetConfirm = '/auth/password-reset/confirm';

  static const Set<String> unauthenticated = {
    login,
    register,
    passwordResetRequest,
    passwordResetConfirm,
  };

  static bool isUnauthenticated(String path) {
    return unauthenticated.any((endpoint) => _matches(path, endpoint));
  }

  static bool _matches(String path, String endpoint) {
    return path == endpoint || path.endsWith(endpoint);
  }
}
