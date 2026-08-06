import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shop_space/core/errors/failures.dart';
import 'package:shop_space/core/network/token_refresher.dart';
import 'package:shop_space/core/storage/token_storage.dart';

class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  group('TokenRefresher', () {
    late MockTokenStorage storage;

    setUp(() {
      storage = MockTokenStorage();
    });

    const stored = AuthTokens(
      accessToken: 'old-access',
      refreshToken: 'old-refresh',
    );
    const refreshed = AuthTokens(
      accessToken: 'new-access',
      refreshToken: 'new-refresh',
    );

    test('returns null when no tokens are stored', () async {
      when(() => storage.read()).thenAnswer((_) async => null);
      var delegateCalls = 0;
      final refresher = TokenRefresher(
        storage: storage,
        refreshTokens: (_) async {
          delegateCalls += 1;
          return refreshed;
        },
      );

      expect(await refresher.refresh(), isNull);
      expect(delegateCalls, 0);
    });

    test('delegates with the stored refresh token and returns the new pair',
        () async {
      when(() => storage.read()).thenAnswer((_) async => stored);
      AuthTokens? delegateInput;
      final refresher = TokenRefresher(
        storage: storage,
        refreshTokens: (AuthTokens current) async {
          delegateInput = current;
          return refreshed;
        },
      );

      final AuthTokens? result = await refresher.refresh();

      expect(delegateInput?.refreshToken, 'old-refresh');
      expect(result, isNotNull);
      expect(result!.accessToken, 'new-access');
      expect(result.refreshToken, 'new-refresh');
    });

    test('returns null when the delegate returns null', () async {
      when(() => storage.read()).thenAnswer((_) async => stored);
      final refresher = TokenRefresher(
        storage: storage,
        refreshTokens: (_) async => null,
      );

      expect(await refresher.refresh(), isNull);
    });

    test('returns null when the delegate throws a typed Failure', () async {
      when(() => storage.read()).thenAnswer((_) async => stored);
      final refresher = TokenRefresher(
        storage: storage,
        refreshTokens: (_) async =>
            throw const UnauthorizedFailure('unauthorized'),
      );

      expect(await refresher.refresh(), isNull);
    });
  });
}
