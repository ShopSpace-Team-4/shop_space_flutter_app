import 'package:flutter_test/flutter_test.dart';
import 'package:shop_space/features/auth/data/models/auth_tokens.dart';
import 'package:shop_space/features/user/data/models/role_change_response.dart';
import 'package:shop_space/features/user/data/models/user.dart';
import 'package:shop_space/features/user/data/models/user_role.dart';

void main() {
  group('UserRole', () {
    test('serializes as tenant/landlord strings', () {
      expect(UserRole.tenant.name, 'tenant');
      expect(UserRole.landlord.name, 'landlord');
    });
  });

  group('User', () {
    test('round-trips through JSON with tenant/landlord roles', () {
      const user = User(
        id: 'u-1',
        firstName: 'Ahmed',
        lastName: 'Ali',
        email: 'ahmed@example.com',
        phone: '+201234567890',
        roles: [UserRole.tenant, UserRole.landlord],
        activeRole: UserRole.tenant,
        isVerified: true,
        avatarUrl: 'https://example.com/avatar.png',
      );

      final json = user.toJson();

      expect(json['roles'], ['tenant', 'landlord']);
      expect(json['activeRole'], 'tenant');

      final decoded = User.fromJson(json);

      expect(decoded, user);
    });

    test('decodes a tenant-only user', () {
      const json = <String, dynamic>{
        'id': 'u-2',
        'firstName': 'Sara',
        'lastName': 'Hassan',
        'email': 'sara@example.com',
        'phone': '+201112223333',
        'roles': <dynamic>['tenant'],
        'activeRole': 'tenant',
        'isVerified': true,
      };

      final user = User.fromJson(json);

      expect(user.roles, [UserRole.tenant]);
      expect(user.activeRole, UserRole.tenant);
      expect(user.avatarUrl, isNull);
    });
  });

  group('RoleChangeResponse', () {
    test('composes tokens and user', () {
      const tokens = AuthTokens(
        accessToken: 'new-access',
        refreshToken: 'new-refresh',
      );
      const user = User(
        id: 'u-1',
        firstName: 'Ahmed',
        lastName: 'Ali',
        email: 'ahmed@example.com',
        phone: '+201234567890',
        roles: [UserRole.tenant, UserRole.landlord],
        activeRole: UserRole.landlord,
        isVerified: true,
      );

      const response = RoleChangeResponse(tokens: tokens, user: user);

      expect(response.tokens, tokens);
      expect(response.user.roles, contains(UserRole.landlord));
      expect(response.user.activeRole, UserRole.landlord);
    });
  });
}
