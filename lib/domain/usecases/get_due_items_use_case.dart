import '../models/user_progress_model.dart';
import '../repositories/progress_repository.dart';

class GetDueItemsUseCase {
  GetDueItemsUseCase(this._repository);

  final ProgressRepository _repository;

  /// Returns items due for review, sorted by most overdue first.
  Future<List<UserProgressModel>> call() {
    return _repository.getDueItems();
  }
}
