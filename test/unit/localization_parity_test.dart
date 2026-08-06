import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const String _enPath = 'lib/core/localization/app_en.arb';
const String _arPath = 'lib/core/localization/app_ar.arb';

/// Keys are the top-level JSON entries that do not start with `@` (which are
/// gen-l10n metadata blocks like `@key`).
Set<String> _keys(Map<String, dynamic> arb) =>
    arb.keys.where((key) => !key.startsWith('@')).toSet();

Map<String, String> _values(Map<String, dynamic> arb) => Map.fromEntries(
      arb.entries
          .where((entry) => !entry.key.startsWith('@'))
          .map((entry) => MapEntry(entry.key, entry.value as String)),
    );

void main() {
  final File enFile = File(_enPath);
  final File arFile = File(_arPath);

  final Map<String, dynamic> en = jsonDecode(enFile.readAsStringSync());
  final Map<String, dynamic> ar = jsonDecode(arFile.readAsStringSync());

  test('every key exists in both English and Arabic', () {
    final Set<String> enKeys = _keys(en);
    final Set<String> arKeys = _keys(ar);

    expect(
      enKeys.difference(arKeys),
      isEmpty,
      reason: 'missing in Arabic',
    );
    expect(
      arKeys.difference(enKeys),
      isEmpty,
      reason: 'missing in English',
    );
  });

  test('every key has a non-empty value in both locales', () {
    final Map<String, String> enValues = _values(en);
    final Map<String, String> arValues = _values(ar);

    for (final MapEntry(key: key, value: value) in enValues.entries) {
      expect(value.trim(), isNotEmpty, reason: 'English "$key" is empty');
    }
    for (final MapEntry(key: key, value: value) in arValues.entries) {
      expect(value.trim(), isNotEmpty, reason: 'Arabic "$key" is empty');
    }
  });
}
