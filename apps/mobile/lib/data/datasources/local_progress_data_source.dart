import 'package:shared_preferences/shared_preferences.dart';

class LocalProgressDataSource {
  static const _completedLessonIdsKey = 'completed_lesson_ids';

  Future<Set<String>> loadCompletedLessonIds() async {
    final preferences = await SharedPreferences.getInstance();
    final values = preferences.getStringList(_completedLessonIdsKey) ?? <String>[];
    return values.toSet();
  }

  Future<void> markCompleted(String lessonId) async {
    final preferences = await SharedPreferences.getInstance();
    final values = await loadCompletedLessonIds();
    values.add(lessonId);
    await preferences.setStringList(_completedLessonIdsKey, values.toList());
  }

  Future<void> reset() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_completedLessonIdsKey);
  }
}
