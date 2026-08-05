import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shop_space/core/storage/token_storage.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage storage;
  late SecureTokenStorage tokenStorage;

  setUp(() {
    storage = MockFlutterSecureStorage();
    tokenStorage = SecureTokenStorage(storage: storage);
  });

  test('write stores tokens under namespaced keys', () async {
    when(
      () => storage.write(key: any(named: 'key'), value: any(named: 'value')),
    ).thenAnswer((_) async {});

    await tokenStorage.write(
      const AuthTokens(accessToken: 'access-1', refreshToken: 'refresh-1'),
    );

    verify(
      () => storage.write(key: 'auth.accessToken', value: 'access-1'),
    ).called(1);
    verify(
      () => storage.write(key: 'auth.refreshToken', value: 'refresh-1'),
    ).called(1);
  });

  test('read round-trips tokens stored by write', () async {
    when(
      () => storage.read(key: 'auth.accessToken'),
    ).thenAnswer((_) async => 'access-1');
    when(
      () => storage.read(key: 'auth.refreshToken'),
    ).thenAnswer((_) async => 'refresh-1');

    final AuthTokens? tokens = await tokenStorage.read();

    expect(tokens, isNotNull);
    expect(tokens!.accessToken, 'access-1');
    expect(tokens.refreshToken, 'refresh-1');
  });

  test('read returns null when no tokens are stored', () async {
    when(() => storage.read(key: any(named: 'key'))).thenAnswer((_) async => null);

    expect(await tokenStorage.read(), isNull);
  });

  test('read returns null when only one token is present', () async {
    when(
      () => storage.read(key: 'auth.accessToken'),
    ).thenAnswer((_) async => 'access-1');
    when(
      () => storage.read(key: 'auth.refreshToken'),
    ).thenAnswer((_) async => null);

    expect(await tokenStorage.read(), isNull);
  });

  test('clear deletes both namespaced keys', () async {
    when(() => storage.delete(key: any(named: 'key'))).thenAnswer((_) async {});

    await tokenStorage.clear();

    verify(() => storage.delete(key: 'auth.accessToken')).called(1);
    verify(() => storage.delete(key: 'auth.refreshToken')).called(1);
  });
}
