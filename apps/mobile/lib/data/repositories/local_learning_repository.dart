import '../../domain/entities/learning_models.dart';
import '../../domain/repositories/learning_repository.dart';
import '../datasources/local_content_data_source.dart';
import '../datasources/local_progress_data_source.dart';

class LocalLearningRepository implements LearningRepository {
  LocalLearningRepository({
    required LocalContentDataSource contentDataSource,
    required LocalProgressDataSource progressDataSource,
  })  : _contentDataSource = contentDataSource,
        _progressDataSource = progressDataSource;

  final LocalContentDataSource _contentDataSource;
  final LocalProgressDataSource _progressDataSource;

  Map<String, dynamic>? _cachedManifest;

  Future<Map<String, dynamic>> _loadManifest() async {
    _cachedManifest ??= await _contentDataSource.loadManifest();
    return _cachedManifest!;
  }

  @override
  Future<DashboardSnapshot> loadDashboard() async {
    final manifest = await _loadManifest();
    final courses = await loadCourses();

    return DashboardSnapshot(
      companyNews: _parseFeedItems(manifest['companyNews']),
      usefulMaterials: _parseFeedItems(manifest['usefulMaterials']),
      courses: courses,
      continueLesson: _findContinueLesson(courses),
    );
  }

  @override
  Future<List<Course>> loadCourses() async {
    final manifest = await _loadManifest();
    final completedLessonIds =
        await _progressDataSource.loadCompletedLessonIds();
    final rawCourses = (manifest['courses'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<dynamic, dynamic>>()
        .map((rawCourse) => Map<String, dynamic>.from(rawCourse))
        .toList();

    return rawCourses
        .map((rawCourse) => _parseCourse(rawCourse, completedLessonIds))
        .toList();
  }

  @override
  Future<Course> loadCourse(String courseId) async {
    final courses = await loadCourses();

    for (final course in courses) {
      if (course.id == courseId) {
        return course;
      }
    }

    throw StateError('Course $courseId was not found');
  }

  @override
  Future<Lesson> loadLesson(String courseId, String lessonId) async {
    final course = await loadCourse(courseId);

    for (final lesson in course.lessons) {
      if (lesson.id == lessonId) {
        return lesson;
      }
    }

    throw StateError('Lesson $lessonId was not found');
  }

  @override
  Future<ProfileSummary> loadProfileSummary() async {
    final courses = await loadCourses();

    final totalCourses = courses.length;
    final totalLessons =
        courses.fold<int>(0, (sum, course) => sum + course.lessonCount);
    final completedCourses =
        courses.where((course) => course.isCompleted).length;
    final completedLessons = courses.fold<int>(
      0,
      (sum, course) => sum + course.completedLessons,
    );

    return ProfileSummary(
      totalCourses: totalCourses,
      totalLessons: totalLessons,
      completedCourses: completedCourses,
      completedLessons: completedLessons,
      courses: courses,
    );
  }

  @override
  Future<void> markLessonCompleted(String lessonId) async {
    await _progressDataSource.markCompleted(lessonId);
  }

  @override
  Future<void> resetProgress() async {
    await _progressDataSource.reset();
  }

  Course _parseCourse(
    Map<String, dynamic> rawCourse,
    Set<String> completedLessonIds,
  ) {
    final rawLessons =
        (rawCourse['lessons'] as List<dynamic>? ?? <dynamic>[])
            .whereType<Map<dynamic, dynamic>>()
            .map((rawLesson) => Map<String, dynamic>.from(rawLesson))
            .toList()
          ..sort((left, right) {
            final leftOrder = (left['order'] as num?)?.toInt() ?? 0;
            final rightOrder = (right['order'] as num?)?.toInt() ?? 0;
            return leftOrder.compareTo(rightOrder);
          });

    final lessons = rawLessons
        .map((rawLesson) => _parseLesson(rawLesson, completedLessonIds))
        .toList();

    return Course(
      id: rawCourse['id'] as String? ?? '',
      title: rawCourse['title'] as String? ?? '',
      subtitle: rawCourse['subtitle'] as String? ?? '',
      description: rawCourse['description'] as String? ?? '',
      lessonCount: (rawCourse['lessonCount'] as num?)?.toInt() ?? lessons.length,
      totalDurationLabel: rawCourse['totalDurationLabel'] as String? ?? '',
      lessons: lessons,
    );
  }

  Lesson _parseLesson(
    Map<String, dynamic> rawLesson,
    Set<String> completedLessonIds,
  ) {
    final lessonId = rawLesson['id'] as String? ?? '';
    final rawVideo = rawLesson['video'];
    final rawMaterials =
        (rawLesson['materials'] as List<dynamic>? ?? <dynamic>[])
            .whereType<Map<dynamic, dynamic>>()
            .map((rawMaterial) => Map<String, dynamic>.from(rawMaterial))
            .toList();

    return Lesson(
      id: lessonId,
      courseId: rawLesson['courseId'] as String? ?? '',
      order: (rawLesson['order'] as num?)?.toInt() ?? 0,
      title: rawLesson['title'] as String? ?? '',
      summary: rawLesson['summary'] as String? ?? '',
      description: rawLesson['description'] as String? ?? '',
      status: rawLesson['status'] as String? ?? '',
      durationLabel: rawLesson['durationLabel'] as String?,
      video: rawVideo is Map<dynamic, dynamic>
          ? LessonVideo(
              title: rawVideo['title'] as String? ?? 'Видео урока',
              uri: rawVideo['uri'] as String? ?? '',
              durationLabel: rawVideo['durationLabel'] as String?,
            )
          : null,
      materials: rawMaterials
          .map(
            (rawMaterial) => LessonMaterial(
              id: rawMaterial['id'] as String? ?? '',
              type: rawMaterial['type'] as String? ?? '',
              title: rawMaterial['title'] as String? ?? '',
              uri: rawMaterial['uri'] as String? ?? '',
            ),
          )
          .toList(),
      isCompleted: completedLessonIds.contains(lessonId),
    );
  }

  List<HomeFeedItem> _parseFeedItems(Object? rawItems) {
    final items = (rawItems as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<dynamic, dynamic>>()
        .map((rawItem) => Map<String, dynamic>.from(rawItem))
        .toList();

    return items
        .map(
          (rawItem) => HomeFeedItem(
            id: rawItem['id'] as String? ?? '',
            title: rawItem['title'] as String? ?? '',
            description: rawItem['description'] as String? ?? '',
            dateLabel: rawItem['dateLabel'] as String? ?? '',
          ),
        )
        .toList();
  }

  Lesson? _findContinueLesson(List<Course> courses) {
    for (final course in courses) {
      final nextLesson = course.nextLesson;
      if (nextLesson != null) {
        return nextLesson;
      }
    }

    return null;
  }
}
