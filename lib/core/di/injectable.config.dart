// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shop_space/core/di/modules.dart' as _i231;
import 'package:shop_space/core/env/app_env.dart' as _i202;
import 'package:shop_space/core/errors/error_mapper.dart' as _i1040;
import 'package:shop_space/core/localization/localization_cubit.dart' as _i756;
import 'package:shop_space/core/network/session_controller.dart' as _i560;
import 'package:shop_space/core/network/token_provider.dart' as _i33;
import 'package:shop_space/core/network/token_refresher.dart' as _i937;
import 'package:shop_space/core/router/app_router.dart' as _i838;
import 'package:shop_space/core/router/route_guards.dart' as _i645;
import 'package:shop_space/core/storage/preferences_service.dart' as _i514;
import 'package:shop_space/core/storage/token_storage.dart' as _i814;
import 'package:shop_space/features/auth/data/auth_datasource.dart' as _i287;
import 'package:shop_space/features/auth/repository/auth_repository.dart'
    as _i951;
import 'package:shop_space/features/user/data/user_datasource.dart' as _i983;
import 'package:shop_space/features/user/repository/user_repository.dart'
    as _i251;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final coreModule = _$CoreModule();
    gh.singleton<_i202.AppEnv>(() => coreModule.appEnv);
    gh.singleton<_i814.TokenStorage>(() => coreModule.tokenStorage);
    gh.singleton<_i514.PreferencesService>(() => coreModule.preferencesService);
    gh.singleton<_i1040.ErrorMapper>(() => coreModule.errorMapper);
    gh.singleton<_i838.AppRouter>(() => _i838.AppRouter());
    gh.singleton<_i33.TokenProvider>(
      () => coreModule.tokenProvider(gh<_i814.TokenStorage>()),
    );
    gh.singleton<_i560.SessionController>(
      () => coreModule.sessionController(gh<_i814.TokenStorage>()),
    );
    gh.singleton<_i937.TokenRefresher>(
      () => coreModule.tokenRefresher(gh<_i814.TokenStorage>()),
    );
    gh.singleton<_i645.SessionReader>(() => const _i645.DefaultSessionReader());
    gh.singleton<_i756.LocalizationCubit>(
      () => _i756.LocalizationCubit(gh<_i514.PreferencesService>()),
    );
    gh.singleton<_i361.Dio>(
      () => coreModule.dio(
        gh<_i202.AppEnv>(),
        gh<_i33.TokenProvider>(),
        gh<_i937.TokenRefresher>(),
        gh<_i560.SessionController>(),
        gh<_i1040.ErrorMapper>(),
      ),
    );
    gh.factory<_i287.AuthDataSource>(
      () => _i287.AuthDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.factory<_i983.UserDataSource>(
      () => _i983.UserDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.factory<_i251.UserRepository>(
      () => _i251.UserRepositoryImpl(
        gh<_i983.UserDataSource>(),
        gh<_i560.SessionController>(),
      ),
    );
    gh.factory<_i951.AuthRepository>(
      () => _i951.AuthRepositoryImpl(gh<_i287.AuthDataSource>()),
    );
    return this;
  }
}

class _$CoreModule extends _i231.CoreModule {}
