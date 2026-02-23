import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../core/errors/app_error.dart';

class JsonContentLoader {
  static const _basePath = 'assets/data';

  Future<List<int>> discoverLevels() async {
    final levels = <int>[];
    for (var i = 1; i <= 15; i++) {
      try {
        final path = '$_basePath/level_${i.toString().padLeft(2, '0')}/metadata.json';
        await rootBundle.loadString(path);
        levels.add(i);
      } on FlutterError {
        // Asset not found — level doesn't exist, skip
      } catch (e) {
        // Unexpected error (corrupted JSON, I/O) — log but don't block discovery
        debugPrint('Warning: error probing level $i: $e');
      }
    }
    return levels;
  }

  Future<Map<String, dynamic>> loadMetadata(int levelNumber) async {
    try {
      final path =
          '$_basePath/level_${levelNumber.toString().padLeft(2, '0')}/metadata.json';
      final jsonString = await rootBundle.loadString(path);
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw ContentError(
        'Failed to load metadata for level $levelNumber',
        debugInfo: e.toString(),
      );
    }
  }

  Future<List<Map<String, dynamic>>> loadWords(int levelNumber) async {
    try {
      final path =
          '$_basePath/level_${levelNumber.toString().padLeft(2, '0')}/words.json';
      final jsonString = await rootBundle.loadString(path);
      final list = json.decode(jsonString) as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    } catch (e) {
      throw ContentError(
        'Failed to load words for level $levelNumber',
        debugInfo: e.toString(),
      );
    }
  }

  Future<List<Map<String, dynamic>>> loadVerbs(int levelNumber) async {
    try {
      final path =
          '$_basePath/level_${levelNumber.toString().padLeft(2, '0')}/verbs.json';
      final jsonString = await rootBundle.loadString(path);
      final list = json.decode(jsonString) as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    } catch (e) {
      throw ContentError(
        'Failed to load verbs for level $levelNumber',
        debugInfo: e.toString(),
      );
    }
  }
}
