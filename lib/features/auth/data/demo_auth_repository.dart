import 'package:syzygy_foundation_flutter/syzygy_foundation_flutter.dart'
    show AuthToken, Authenticated;
import 'package:syzygy_services_flutter/syzygy_services_flutter.dart';

import '../domain/auth_use_case.dart';

/// Offline demo login used when the app is not connected to a backend.
///
/// Demo values only. These are not secrets and grant access to nothing but
/// this example app. Selected in `di/app_module.dart` by `useDemoLogin`.
abstract final class DemoCredentials {
  static const String email = 'demo@syzygy.example';
  static const String password = 'demo-password';
}

/// [AuthRepository] that accepts only [DemoCredentials] and stores the demo
/// session through [TokenAuthProvider], the same provider the real repository
/// uses. It makes no network calls.
class DemoAuthRepository implements AuthRepository {
  DemoAuthRepository(this._authProvider);

  final TokenAuthProvider _authProvider;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final matches = email.trim().toLowerCase() == DemoCredentials.email &&
        password == DemoCredentials.password;
    if (!matches) {
      throw ArgumentError('Invalid email or password.');
    }
    _authProvider.authenticate(
      const AuthToken(accessToken: 'demo-access-token', refreshToken: null),
    );
    return const AuthUser(
      id: 'demo-user',
      email: DemoCredentials.email,
      name: 'Demo User',
    );
  }

  @override
  Future<void> logout() async {
    _authProvider.signOut();
  }

  @override
  Future<AuthUser?> currentUser() async {
    if (_authProvider.state is Authenticated) {
      return const AuthUser(
        id: 'demo-user',
        email: DemoCredentials.email,
        name: 'Demo User',
      );
    }
    return null;
  }
}
