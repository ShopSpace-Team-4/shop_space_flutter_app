import 'dart:io';

/// One-command quality gate (ln / FR-012): runs `flutter analyze`, prints
/// results, and exits non-zero on failure. Analyze only — the test suite has
/// been removed.
///
/// Run via `dart run tool/quality.dart`.
Future<void> main() async {
  stdout.writeln('ShopSpace quality gate');
  stdout.writeln('---------------------------------------------');

  final int analyzeExit = await _runStep('flutter analyze', const ['analyze']);

  stdout.writeln('---------------------------------------------');
  if (analyzeExit == 0) {
    stdout.writeln('PASS: analyze clean.');
    return;
  }
  stderr.writeln('FAIL: quality gate failed (analyze=$analyzeExit).');
  exit(1);
}

Future<int> _runStep(String label, List<String> args) async {
  stdout.writeln('\nRunning $label ...');
  final ProcessResult result = Platform.isWindows
      ? await Process.run('cmd', <String>['/c', 'flutter', ...args])
      : await Process.run('flutter', args);

  final String out = result.stdout.toString();
  final String err = result.stderr.toString();
  if (out.isNotEmpty) {
    stdout.write(out);
  }
  if (err.isNotEmpty) {
    stderr.write(err);
  }

  if (result.exitCode == 0) {
    stdout.writeln('\n$label: OK');
  } else {
    stderr.writeln('\n$label: FAILED (exit ${result.exitCode})');
  }
  return result.exitCode;
}
