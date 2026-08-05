import 'package:flutter_test/flutter_test.dart';
import 'package:shop_space/core/env/app_env.dart';

void main() {
  group('AppEnvironment', () {
    test('exposes dev, staging and prod', () {
      expect(AppEnvironment.values, hasLength(3));
      expect(
        AppEnvironment.values,
        containsAll(<AppEnvironment>[
          AppEnvironment.dev,
          AppEnvironment.staging,
          AppEnvironment.prod,
        ]),
      );
    });
  });

  group('AppEnv constant environments', () {
    test('dev defaults to localhost:3000 with logging enabled', () {
      expect(AppEnv.dev.name, AppEnvironment.dev);
      expect(AppEnv.dev.apiBaseUrl, 'http://localhost:3000');
      expect(AppEnv.dev.isLoggingEnabled, isTrue);
      expect(AppEnv.dev.isRelease, isFalse);
    });

    test('staging uses staging.shopspace.app with logging enabled', () {
      expect(AppEnv.staging.name, AppEnvironment.staging);
      expect(AppEnv.staging.apiBaseUrl, 'https://staging.shopspace.app');
      expect(AppEnv.staging.isLoggingEnabled, isTrue);
      expect(AppEnv.staging.isRelease, isFalse);
    });

    test('prod uses api.shopspace.app with logging disabled', () {
      expect(AppEnv.prod.name, AppEnvironment.prod);
      expect(AppEnv.prod.apiBaseUrl, 'https://api.shopspace.app');
      expect(AppEnv.prod.isLoggingEnabled, isFalse);
      expect(AppEnv.prod.isRelease, isTrue);
    });
  });

  group('AppEnv.fromDartDefine', () {
    test('resolves to a supported environment', () {
      final AppEnv env = AppEnv.fromDartDefine();
      expect(AppEnvironment.values, contains(env.name));
    });

    test('defaults to dev (localhost:3000) without an APP_ENV define', () {
      final AppEnv env = AppEnv.fromDartDefine();
      expect(env.name, AppEnvironment.dev);
      expect(env.apiBaseUrl, 'http://localhost:3000');
    });
  });
}
