import 'package:flutter_test/flutter_test.dart';
import 'package:shop_space/core/network/envelope.dart';

void main() {
  group('ApiEnvelope', () {
    test('parses message, status and data', () {
      const json = <String, dynamic>{
        'message': 'ok',
        'status': 'success',
        'data': <String, dynamic>{
          'accessToken': 'access',
          'refreshToken': 'refresh',
        },
      };

      final envelope = ApiEnvelope<Map<String, dynamic>>.fromJson(json);

      expect(envelope.message, 'ok');
      expect(envelope.status, 'success');
      expect(envelope.data['accessToken'], 'access');
      expect(envelope.data['refreshToken'], 'refresh');
    });

    test('defaults missing message and status to empty strings', () {
      const json = <String, dynamic>{
        'data': <String, dynamic>{'id': '1'},
      };

      final envelope = ApiEnvelope<Map<String, dynamic>>.fromJson(json);

      expect(envelope.message, isEmpty);
      expect(envelope.status, isEmpty);
      expect(envelope.data['id'], '1');
    });

    test('wraps list data without changes', () {
      const json = <String, dynamic>{
        'message': 'ok',
        'status': 'success',
        'data': <dynamic>['a', 'b'],
      };

      final envelope = ApiEnvelope<List<dynamic>>.fromJson(json);

      expect(envelope.data, ['a', 'b']);
    });
  });
}
