import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shop_space/core/errors/failures.dart';
import 'package:shop_space/core/network/session_controller.dart';
import 'package:shop_space/core/storage/token_storage.dart';
import 'package:shop_space/features/auth/data/models/auth_tokens.dart' as feature;
import 'package:shop_space/features/user/data/models/active_role_update_request.dart';
import 'package:shop_space/features/user/data/models/password_change_request.dart';
import 'package:shop_space/features/user/data/models/role_change_request.dart';
import 'package:shop_space/features/user/data/models/role_change_response.dart';
import 'package:shop_space/features/user/data/models/user.dart';
import 'package:shop_space/features/user/data/models/user_role.dart';
import 'package:shop_space/features/user/data/user_datasource.dart';
import 'package:shop_space/features/user/repository/user_repository.dart';

class MockUserDataSource extends Mock implements UserDataSource {}

class MockSessionController extends Mock implements SessionController {}

void main() {
  group('UserRepositoryImpl', () {
    late MockUserDataSource dataSource;
    late MockSessionController session;
    late UserRepositoryImpl repository;

    const user = User(
      id: 'u1',
      firstName: 'Omar',
      lastName: 'Hassan',
      email: 'omar@example.com',
      phone: '+201000000000',
      roles: [UserRole.tenant, UserRole.landlord],
      activeRole: UserRole.landlord,
      isVerified: true,
    );
    const featureTokens = feature.AuthTokens(
      accessToken: 'new-access',
      refreshToken: 'new-refresh',
    );
    const roleChangeResponse = RoleChangeResponse(
      tokens: featureTokens,
      user: user,
    );

    setUpAll(() {
      registerFallbackValue(const ActiveRoleUpdateRequest(role: UserRole.tenant));
      registerFallbackValue(const RoleChangeRequest(role: UserRole.tenant));
      registerFallbackValue(
        const PasswordChangeRequest(currentPassword: 'p', newPassword: 'n'),
      );
      registerFallbackValue(const AuthTokens(accessToken: 'a', refreshToken: 'r'));
    });

    setUp(() {
      dataSource = MockUserDataSource();
      session = MockSessionController();
      repository = UserRepositoryImpl(dataSource, session);
    });

    test('getProfile delegates to UserDataSource', () async {
      when(() => dataSource.getProfile()).thenAnswer((_) async => user);

      expect(await repository.getProfile(), user);

      verify(() => dataSource.getProfile()).called(1);
    });

    test('switchActiveRole builds the request with the role and returns User',
        () async {
      when(() => dataSource.switchActiveRole(any()))
          .thenAnswer((_) async => user);

      expect(await repository.switchActiveRole(UserRole.landlord), user);

      final captured =
          verify(() => dataSource.switchActiveRole(captureAny())).captured;
      final request = captured.single as ActiveRoleUpdateRequest;
      expect(request.role, UserRole.landlord);
    });

    test('addRole persists the fresh token pair BEFORE returning the User',
        () async {
      final calls = <String>[];
      when(() => dataSource.addRole(any())).thenAnswer((_) async {
        calls.add('addRole');
        return roleChangeResponse;
      });
      when(() => session.onTokensUpdated(any())).thenAnswer((_) async {
        calls.add('persistTokens');
      });

      final User result = await repository.addRole(UserRole.landlord);

      expect(result, user);
      expect(calls, ['addRole', 'persistTokens']);

      final roleCaptured =
          verify(() => dataSource.addRole(captureAny())).captured;
      final roleRequest = roleCaptured.single as RoleChangeRequest;
      expect(roleRequest.role, UserRole.landlord);

      final tokensCaptured =
          verify(() => session.onTokensUpdated(captureAny())).captured;
      final persisted = tokensCaptured.single as AuthTokens;
      expect(persisted.accessToken, 'new-access');
      expect(persisted.refreshToken, 'new-refresh');
    });

    test('addRole propagates the datasource Failure before persisting tokens',
        () {
      when(() => dataSource.addRole(any()))
          .thenThrow(const ValidationFailure('server_error'));

      expect(
        () => repository.addRole(UserRole.landlord),
        throwsA(isA<ValidationFailure>()),
      );

      verifyNever(() => session.onTokensUpdated(any()));
    });

    test('changePassword builds the request and delegates', () async {
      when(() => dataSource.changePassword(any())).thenAnswer((_) async {});

      await repository.changePassword(
        currentPassword: 'OldPass123',
        newPassword: 'NewPass123',
      );

      final captured =
          verify(() => dataSource.changePassword(captureAny())).captured;
      final request = captured.single as PasswordChangeRequest;
      expect(request.currentPassword, 'OldPass123');
      expect(request.newPassword, 'NewPass123');
    });
  });
}
