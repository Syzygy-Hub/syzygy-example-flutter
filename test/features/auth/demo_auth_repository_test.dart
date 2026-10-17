import 'package:flutter_test/flutter_test.dart';
import 'package:syzygy_example/di/app_module.dart';
import 'package:syzygy_example/features/auth/data/demo_auth_repository.dart';
import 'package:syzygy_foundation_flutter/syzygy_foundation_flutter.dart'
    show Authenticated;
import 'package:syzygy_services_flutter/syzygy_services_flutter.dart';

void main() {
  late TokenAuthProvider auth;
  late DemoAuthRepository repository;

  setUp(() async {
    await resetDI();
    await initDI();
    auth = appContainer.resolve<TokenAuthProvider>();
    repository = DemoAuthRepository(auth);
  });

  tearDown(() async {
    await resetDI();
  });

  test('valid demo login signs the session in', () async {
    final user = await repository.login(
      email: DemoCredentials.email,
      password: DemoCredentials.password,
    );

    expect(user.email, DemoCredentials.email);
    expect(auth.state, isA<Authenticated>());
    expect(await repository.currentUser(), isNotNull);
  });

  test('wrong password is rejected and the session stays signed out', () async {
    await expectLater(
      repository.login(
        email: DemoCredentials.email,
        password: 'not-the-password',
      ),
      throwsArgumentError,
    );

    expect(auth.state, isNot(isA<Authenticated>()));
  });

  test('logout clears the demo session', () async {
    await repository.login(
      email: DemoCredentials.email,
      password: DemoCredentials.password,
    );

    await repository.logout();

    expect(auth.state, isNot(isA<Authenticated>()));
    expect(await repository.currentUser(), isNull);
  });
}
