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

  static const String _devBaseUrl = 'http://localhost:3000';
  static const String _stagingBaseUrl = 'https://staging.shopspace.app';
  static const String _prodBaseUrl = 'https://api.shopspace.app';

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

  factory AppEnv.fromDartDefine() {
    const String value = String.fromEnvironment('APP_ENV');
    return switch (value) {
      'staging' => staging,
      'prod' => prod,
      _ => dev,
    };
  }
}
