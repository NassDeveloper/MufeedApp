abstract class ErrorReportRepository {
  Future<void> submitReport({
    required int itemId,
    required String contentType,
    required String category,
    String? comment,
  });
}
