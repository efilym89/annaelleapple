import '../entities/learning_models.dart';

abstract class LearningRepository {
  Future<DashboardSnapshot> loadDashboard();
  Future<List<Course>> loadCourses();
  Future<Course> loadCourse(String courseId);
  Future<Lesson> loadLesson(String courseId, String lessonId);
  Future<ProfileSummary> loadProfileSummary();
  Future<void> markLessonCompleted(String lessonId);
  Future<void> resetProgress();
}
