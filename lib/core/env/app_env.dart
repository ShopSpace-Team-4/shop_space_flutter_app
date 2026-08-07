enum AppEnvironment { dev, staging, prod }

class AppEnv {
  const AppEnv({
    required this.name,
    required this.apiBaseUrl,
    required this.isLoggingEnabled,
    required this.isRelease,
  });

  final AppEnvironment name;
  final String apiBaseUrl;
  final bool isLoggingEnabled;
  final bool isRelease;

  static const String _devBaseUrl =
      'https://shopspace-backend-production.up.railway.app';
  static const String _stagingBaseUrl =
      'https://shopspace-backend-production.up.railway.app';
  static const String _prodBaseUrl =
      'https://shopspace-backend-production.up.railway.app';

  static const AppEnv dev = AppEnv(
    name: AppEnvironment.dev,
    apiBaseUrl: _devBaseUrl,
    isLoggingEnabled: true,
    isRelease: false,
  );

  static const AppEnv staging = AppEnv(
    name: AppEnvironment.staging,
    apiBaseUrl: _stagingBaseUrl,
    isLoggingEnabled: true,
    isRelease: false,
  );

  static const AppEnv prod = AppEnv(
    name: AppEnvironment.prod,
    apiBaseUrl: _prodBaseUrl,
    isLoggingEnabled: false,
    isRelease: true,
  );

  /// Android web client ID for Google Sign-In, passed as `serverClientId` when
  /// `google-services.json` is absent (contract `google-signin-flow.md`).
  /// Empty in dev → the plugin falls back to platform provisioning, which is a
  /// dev/ops step; the app must build and run without it (T026).
  static const String googleServerClientId =
      String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');

  factory AppEnv.fromDartDefine() {
    const String value = String.fromEnvironment('APP_ENV');
    const String baseOverride = String.fromEnvironment('API_BASE_URL');
    return switch (value) {
      'staging' => staging,
      'prod' => prod,
      _ => baseOverride.isNotEmpty
          ? const AppEnv(
              name: AppEnvironment.dev,
              apiBaseUrl: baseOverride,
              isLoggingEnabled: true,
              isRelease: false,
            )
          : dev,
    };
  }
}
