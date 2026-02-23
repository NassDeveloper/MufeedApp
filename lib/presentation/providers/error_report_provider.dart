import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/error_report_repository.dart';

final errorReportRepositoryProvider = Provider<ErrorReportRepository>((ref) {
  throw UnimplementedError(
    'errorReportRepositoryProvider must be overridden in ProviderScope',
  );
});
