import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../domain/repositories/error_report_repository.dart';
import '../database/app_database.dart';

class ErrorReportRepositoryImpl implements ErrorReportRepository {
  ErrorReportRepositoryImpl(this._db);

  final AppDatabase _db;

  static const _webhookUrl = String.fromEnvironment('DISCORD_WEBHOOK_URL');

  static const _validContentTypes = {
    'vocab',
    'verb',
    'sentence_exercise',
    'verb_table',
  };
  static const _validCategories = {
    'harakat_error',
    'translation_error',
    'other',
  };

  @override
  Future<void> submitReport({
    required int itemId,
    required String contentType,
    required String category,
    String? comment,
  }) async {
    assert(
      _validContentTypes.contains(contentType),
      'Invalid contentType: $contentType',
    );
    assert(
      _validCategories.contains(category),
      'Invalid category: $category',
    );

    await _db.into(_db.errorReports).insert(
          ErrorReportsCompanion.insert(
            itemId: itemId,
            contentType: contentType,
            category: category,
            comment: Value(comment),
          ),
        );

    // Fire-and-forget Discord notification
    if (_webhookUrl.isNotEmpty) {
      _sendToDiscord(
        itemId: itemId,
        contentType: contentType,
        category: category,
        comment: comment,
      );
    }
  }

  Future<void> _sendToDiscord({
    required int itemId,
    required String contentType,
    required String category,
    String? comment,
  }) async {
    try {
      final fields = [
        '**Type:** $contentType',
        '**ID:** $itemId',
        '**Catégorie:** $category',
        if (comment != null && comment.isNotEmpty) '**Commentaire:** $comment',
      ];

      await http.post(
        Uri.parse(_webhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'embeds': [
            {
              'title': 'Signalement d\'erreur',
              'description': fields.join('\n'),
              'color': 0xFF9800, // orange
            },
          ],
        }),
      );
    } catch (e) {
      debugPrint('Discord webhook failed: $e');
    }
  }
}
