import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('lib/ contains no network-related imports', () {
    final libDir = Directory('lib');
    final dartFiles = libDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'));

    final networkPatterns = [
      RegExp(r"import\s+'package:http/"),
      RegExp(r"import\s+'package:dio/"),
      RegExp(r"import\s+'package:firebase_"),
      RegExp(r"import\s+'dart:io'"),
      RegExp(r"import\s+'package:connectivity"),
      RegExp(r"import\s+'package:web_socket"),
    ];

    // Files allowed to use network (fire-and-forget, non-blocking)
    const allowedFiles = {
      'error_report_repository_impl.dart',
    };

    final violations = <String>[];
    for (final file in dartFiles) {
      final fileName = file.uri.pathSegments.last;
      if (allowedFiles.contains(fileName)) continue;
      final content = file.readAsStringSync();
      for (final pattern in networkPatterns) {
        if (pattern.hasMatch(content)) {
          violations.add('${file.path}: matches ${pattern.pattern}');
        }
      }
    }

    expect(violations, isEmpty,
        reason: 'App must be offline-first with no network imports in lib/');
  });
}
