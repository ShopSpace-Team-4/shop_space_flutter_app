import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  /// Read from `.env` (loaded in `bootstrap()` via flutter_dotenv). Empty when
  /// the key is missing or `.env` wasn't loaded → the plugin falls back to
  /// platform provisioning, which is a dev/ops step; the app must build and
  /// run without it (T026).
  static String get googleServerClientId =>
      dotenv.isInitialized ? (dotenv.env['GOOGLE_SERVER_CLIENT_ID'] ?? '') : '';

  /// iOS OAuth client ID for Google Sign-In, passed as `clientId` (takes
  /// precedence over `GoogleService-Info.plist` provisioning). The reversed
  /// client ID must also be registered in `ios/Runner/Info.plist` under
  /// `CFBundleURLTypes`. Empty until the backend provisions the iOS client —
  /// the plugin then falls back to platform provisioning.
  static String get googleIosClientId =>
      dotenv.isInitialized ? (dotenv.env['GOOGLE_IOS_CLIENT_ID'] ?? '') : '';

  /// Resolves the active environment from `.env` (dev/staging/prod), with an
  /// optional `API_BASE_URL` override. Falls back to [dev] when unset or when
  /// `.env` wasn't loaded — the app still builds and runs without config (T026).
  factory AppEnv.fromEnv() {
    final String value = dotenv.isInitialized ? (dotenv.env['APP_ENV'] ?? '') : '';
    final String baseOverride =
        dotenv.isInitialized ? (dotenv.env['API_BASE_URL'] ?? '') : '';
    return switch (value) {
      'staging' => staging,
      'prod' => prod,
      _ => baseOverride.isNotEmpty
          ? AppEnv(
              name: AppEnvironment.dev,
              apiBaseUrl: baseOverride,
              isLoggingEnabled: true,
              isRelease: false,
            )
          : dev,
    };
  }
}
