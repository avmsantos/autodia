import 'package:flutter_test/flutter_test.dart';
import 'package:autodia/core/services/auth_service.dart';

void main() {
  group('AuthService', () {
    test('detecta erros de token antigo para retry', () {
      final service = AuthService();

      expect(
        service.shouldRetryGoogleSignIn(
          'The supplied auth credential is incorrect, malformed or has expired. [ ID Token issued at 1783354763 is stale to sign-in.',
        ),
        isTrue,
      );

      expect(
        service.shouldRetryGoogleSignIn('network-request-failed'),
        isFalse,
      );
    });
  });
}
