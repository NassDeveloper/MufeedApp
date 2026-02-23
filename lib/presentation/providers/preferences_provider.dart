import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/shared_preferences_source.dart';

final sharedPreferencesSourceProvider =
    Provider<SharedPreferencesSource>((ref) {
  throw UnimplementedError(
    'sharedPreferencesSourceProvider must be overridden in ProviderScope',
  );
});
