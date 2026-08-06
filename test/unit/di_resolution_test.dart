import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shop_space/core/di/injectable.dart';
import 'package:shop_space/features/auth/repository/auth_repository.dart';
import 'package:shop_space/features/user/repository/user_repository.dart';

void main() {
  group('DI', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
      await configureDependencies();
    });

    test('resolves AuthRepository', () {
      expect(getIt<AuthRepository>(), isA<AuthRepository>());
    });

    test('AuthRepositoryImpl is wired', () {
      expect(getIt<AuthRepository>(), isA<AuthRepositoryImpl>());
    });

    test('resolves UserRepository', () {
      expect(getIt<UserRepository>(), isA<UserRepository>());
    });

    test('UserRepositoryImpl is wired', () {
      expect(getIt<UserRepository>(), isA<UserRepositoryImpl>());
    });
  });
}
