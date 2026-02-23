import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/data/database/app_database.dart';
import 'package:mufeed_app/core/errors/app_error.dart';
import 'package:mufeed_app/data/datasources/content_importer.dart';
import 'package:mufeed_app/data/datasources/json_content_loader.dart';
import 'package:mufeed_app/data/datasources/shared_preferences_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A testable subclass of JsonContentLoader that returns in-memory data
/// instead of loading from rootBundle.
class FakeJsonContentLoader extends JsonContentLoader {
  FakeJsonContentLoader({
    this.fakeLevels = const [],
    this.fakeMetadata = const {},
    this.fakeWords = const {},
    this.fakeVerbs = const {},
  });

  final List<int> fakeLevels;
  final Map<int, Map<String, dynamic>> fakeMetadata;
  final Map<int, List<Map<String, dynamic>>> fakeWords;
  final Map<int, List<Map<String, dynamic>>> fakeVerbs;

  @override
  Future<List<int>> discoverLevels() async => fakeLevels;

  @override
  Future<Map<String, dynamic>> loadMetadata(int levelNumber) async =>
      fakeMetadata[levelNumber]!;

  @override
  Future<List<Map<String, dynamic>>> loadWords(int levelNumber) async =>
      fakeWords[levelNumber] ?? [];

  @override
  Future<List<Map<String, dynamic>>> loadVerbs(int levelNumber) async =>
      fakeVerbs[levelNumber] ?? [];
}

void main() {
  late AppDatabase db;
  late SharedPreferencesSource prefsSource;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    prefsSource = SharedPreferencesSource(prefs);
  });

  tearDown(() async {
    await db.close();
  });

  group('ContentImporter', () {
    test('importIfNeeded skips when content_version is already current',
        () async {
      await prefsSource.setContentVersion(1);

      final loader = FakeJsonContentLoader(fakeLevels: [1]);
      final importer = ContentImporter(
        database: db,
        jsonLoader: loader,
        prefsSource: prefsSource,
      );

      await importer.importIfNeeded();

      // DB should be empty — import was skipped
      final levels = await db.contentDao.getAllLevels();
      expect(levels, isEmpty);
    });

    test('importIfNeeded imports when content_version is 0', () async {
      final loader = FakeJsonContentLoader(
        fakeLevels: [1],
        fakeMetadata: {
          1: {
            'level': {
              'number': 1,
              'name_fr': 'Niveau 1',
              'name_en': 'Level 1',
              'name_ar': 'المستوى الأول',
              'unit_count': 1,
            },
            'units': [
              {
                'number': 1,
                'name_fr': 'Unité 1',
                'name_en': 'Unit 1',
                'lessons': [
                  {
                    'number': 1,
                    'name_fr': 'Leçon 1',
                    'name_en': 'Lesson 1',
                  },
                ],
              },
            ],
          },
        },
        fakeWords: {
          1: [
            {
              'unit': 1,
              'lesson': 1,
              'arabic': 'كِتَابٌ',
              'translation_fr': 'Livre',
              'sort_order': 1,
            },
          ],
        },
        fakeVerbs: {
          1: [
            {
              'unit': 1,
              'lesson': 1,
              'masdar': 'كِتَابَةٌ',
              'past': 'كَتَبَ',
              'present': 'يَكْتُبُ',
              'imperative': 'اُكْتُبْ',
              'translation_fr': 'Écrire',
              'sort_order': 1,
            },
          ],
        },
      );

      final importer = ContentImporter(
        database: db,
        jsonLoader: loader,
        prefsSource: prefsSource,
      );

      await importer.importIfNeeded();

      // Verify data was imported
      final levels = await db.contentDao.getAllLevels();
      expect(levels, hasLength(1));
      expect(levels.first.nameFr, 'Niveau 1');

      final units = await db.contentDao.getUnitsByLevelId(levels.first.id);
      expect(units, hasLength(1));

      final lessons = await db.contentDao.getLessonsByUnitId(units.first.id);
      expect(lessons, hasLength(1));

      final words = await db.contentDao.getWordsByLessonId(lessons.first.id);
      expect(words, hasLength(1));
      expect(words.first.arabic, 'كِتَابٌ');

      final verbs = await db.contentDao.getVerbsByLessonId(lessons.first.id);
      expect(verbs, hasLength(1));
      expect(verbs.first.masdar, 'كِتَابَةٌ');

      // Verify version was updated
      expect(prefsSource.getContentVersion(), 1);
    });

    test('importIfNeeded does not re-import on second call', () async {
      final loader = FakeJsonContentLoader(
        fakeLevels: [1],
        fakeMetadata: {
          1: {
            'level': {
              'number': 1,
              'name_fr': 'Niveau 1',
              'name_en': 'Level 1',
              'name_ar': 'المستوى الأول',
              'unit_count': 1,
            },
            'units': [
              {
                'number': 1,
                'name_fr': 'Unité 1',
                'name_en': 'Unit 1',
                'lessons': [
                  {
                    'number': 1,
                    'name_fr': 'Leçon 1',
                    'name_en': 'Lesson 1',
                  },
                ],
              },
            ],
          },
        },
        fakeWords: {1: []},
        fakeVerbs: {1: []},
      );

      final importer = ContentImporter(
        database: db,
        jsonLoader: loader,
        prefsSource: prefsSource,
      );

      await importer.importIfNeeded();
      expect(prefsSource.getContentVersion(), 1);

      // Second call should be a no-op
      await importer.importIfNeeded();
      final levels = await db.contentDao.getAllLevels();
      expect(levels, hasLength(1)); // Still just 1, not duplicated
    });

    test('throws ContentError for invalid lesson reference', () async {
      final loader = FakeJsonContentLoader(
        fakeLevels: [1],
        fakeMetadata: {
          1: {
            'level': {
              'number': 1,
              'name_fr': 'N1',
              'name_en': 'L1',
              'name_ar': 'م1',
              'unit_count': 1,
            },
            'units': [
              {
                'number': 1,
                'name_fr': 'U1',
                'name_en': 'U1',
                'lessons': [
                  {'number': 1, 'name_fr': 'L1', 'name_en': 'L1'},
                ],
              },
            ],
          },
        },
        fakeWords: {
          1: [
            {
              'unit': 99,
              'lesson': 99,
              'arabic': 'test',
              'translation_fr': 'test',
              'sort_order': 1,
            },
          ],
        },
        fakeVerbs: {1: []},
      );

      final importer = ContentImporter(
        database: db,
        jsonLoader: loader,
        prefsSource: prefsSource,
      );

      expect(
        () => importer.importIfNeeded(),
        throwsA(isA<ContentError>()),
      );
    });
  });
}
