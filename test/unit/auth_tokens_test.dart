import 'package:flutter_test/flutter_test.dart';
import 'package:shop_space/features/auth/data/models/auth_tokens.dart';

void main() {
  group('AuthTokens', () {
    test('round-trips through JSON', () {
      const tokens = AuthTokens(
        accessToken: 'access-123',
        refreshToken: 'refresh-456',
      );

      final json = tokens.toJson();

      expect(json['accessToken'], 'access-123');
      expect(json['refreshToken'], 'refresh-456');

      final decoded = AuthTokens.fromJson(json);

      expect(decoded, tokens);
    });
  });
}
