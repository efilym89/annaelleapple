class LessonMaterial {
  const LessonMaterial({
    required this.id,
    required this.type,
    required this.title,
    required this.uri,
  });

  final String id;
  final String type;
  final String title;
  final String uri;
}

class LessonVideo {
  const LessonVideo({
    required this.title,
    required this.uri,
    this.durationLabel,
  });

  final String title;
  final String uri;
  final String? durationLabel;
}

class Lesson {
  const Lesson({
    required this.id,
    required this.courseId,
    required this.order,
    required this.title,
    required this.summary,
    required this.description,
    required this.status,
    required this.isCompleted,
    this.durationLabel,
    this.video,
    this.materials = const <LessonMaterial>[],
  });

  final String id;
  final String courseId;
  final int order;
  final String title;
  final String summary;
  final String description;
  final String status;
  final String? durationLabel;
  final LessonVideo? video;
  final List<LessonMaterial> materials;
  final bool isCompleted;

  bool get hasVideo => video != null;
  bool get hasMaterials => materials.isNotEmpty;

  Lesson copyWith({
    bool? isCompleted,
  }) {
    return Lesson(
      id: id,
      courseId: courseId,
      order: order,
      title: title,
      summary: summary,
      description: description,
      status: status,
      durationLabel: durationLabel,
      video: video,
      materials: materials,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class Course {
  const Course({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.lessonCount,
    required this.totalDurationLabel,
    required this.lessons,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final int lessonCount;
  final String totalDurationLabel;
  final List<Lesson> lessons;

  int get completedLessons =>
      lessons.where((lesson) => lesson.isCompleted).length;

  double get progressValue {
    if (lessons.isEmpty) {
      return 0;
    }

    return completedLessons / lessons.length;
  }

  String get progressLabel => '$completedLessons/$lessonCount уроков';

  Lesson? get nextLesson {
    for (final lesson in lessons) {
      if (!lesson.isCompleted) {
        return lesson;
      }
    }

    return lessons.isNotEmpty ? lessons.first : null;
  }

  bool get isCompleted => lessonCount > 0 && completedLessons == lessonCount;
}

class HomeFeedItem {
  const HomeFeedItem({
    required this.id,
    required this.title,
    required this.description,
    required this.dateLabel,
  });

  final String id;
  final String title;
  final String description;
  final String dateLabel;
}

class DashboardSnapshot {
  const DashboardSnapshot({
    required this.companyNews,
    required this.usefulMaterials,
    required this.courses,
    this.continueLesson,
  });

  final List<HomeFeedItem> companyNews;
  final List<HomeFeedItem> usefulMaterials;
  final List<Course> courses;
  final Lesson? continueLesson;
}

class ProfileSummary {
  const ProfileSummary({
    required this.totalCourses,
    required this.totalLessons,
    required this.completedCourses,
    required this.completedLessons,
    required this.courses,
  });

  final int totalCourses;
  final int totalLessons;
  final int completedCourses;
  final int completedLessons;
  final List<Course> courses;

  double get completionRate {
    if (totalLessons == 0) {
      return 0;
    }

    return completedLessons / totalLessons;
  }

  String get completionPercentLabel =>
      '${(completionRate * 100).round()}% завершено';
}
