import 'package:drift/drift.dart';

import '../../domain/repositories/error_report_repository.dart';
import '../database/app_database.dart';

class ErrorReportRepositoryImpl implements ErrorReportRepository {
  ErrorReportRepositoryImpl(this._db);

  final AppDatabase _db;

  static const _validContentTypes = {'vocab', 'verb'};
  static const _validCategories = {'harakat_error', 'translation_error', 'other'};

  @override
  Future<void> submitReport({
    required int itemId,
    required String contentType,
    required String category,
    String? comment,
  }) {
    assert(_validContentTypes.contains(contentType), 'Invalid contentType: $contentType');
    assert(_validCategories.contains(category), 'Invalid category: $category');
    return _db.into(_db.errorReports).insert(
          ErrorReportsCompanion.insert(
            itemId: itemId,
            contentType: contentType,
            category: category,
            comment: Value(comment),
          ),
        );
  }
}
