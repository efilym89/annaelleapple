import 'package:flutter/material.dart';

import '../../../domain/entities/learning_models.dart';
import '../../../domain/repositories/learning_repository.dart';
import '../../lesson/presentation/lesson_screen.dart';

class CourseDetailsScreen extends StatefulWidget {
  const CourseDetailsScreen({
    super.key,
    required this.learningRepository,
    required this.courseId,
    required this.onDataChanged,
  });

  final LearningRepository learningRepository;
  final String courseId;
  final VoidCallback onDataChanged;

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  late Future<Course> _courseFuture;

  @override
  void initState() {
    super.initState();
    _courseFuture = widget.learningRepository.loadCourse(widget.courseId);
  }

  Future<void> _reload() async {
    setState(() {
      _courseFuture = widget.learningRepository.loadCourse(widget.courseId);
    });
  }

  Future<void> _openLesson(Lesson lesson) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => LessonScreen(
          learningRepository: widget.learningRepository,
          courseId: widget.courseId,
          lessonId: lesson.id,
          onDataChanged: widget.onDataChanged,
        ),
      ),
    );

    if (mounted) {
      await _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали курса'),
      ),
      body: FutureBuilder<Course>(
        future: _courseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Не удалось открыть курс. Попробуйте вернуться и повторить попытку.',
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final course = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: theme.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          course.subtitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          course.description,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Chip(label: Text('${course.lessonCount} уроков')),
                            Chip(label: Text(course.totalDurationLabel)),
                            Chip(label: Text(course.progressLabel)),
                          ],
                        ),
                        const SizedBox(height: 18),
                        LinearProgressIndicator(
                          value: course.progressValue,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(999),
                          backgroundColor:
                              theme.colorScheme.primary.withValues(alpha: 0.12),
                        ),
                        if (course.nextLesson != null) ...[
                          const SizedBox(height: 18),
                          FilledButton.icon(
                            onPressed: () => _openLesson(course.nextLesson!),
                            icon: const Icon(Icons.play_circle_fill_rounded),
                            label: const Text('Продолжить обучение'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Уроки',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ...course.lessons.map(
                  (lesson) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: lesson.isCompleted
                              ? theme.colorScheme.primaryContainer
                              : theme.colorScheme.surfaceContainerHighest,
                          foregroundColor: lesson.isCompleted
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                          child: lesson.isCompleted
                              ? const Icon(Icons.check_rounded)
                              : Text('${lesson.order}'),
                        ),
                        title: Text(lesson.title),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            lesson.durationLabel == null
                                ? lesson.summary
                                : '${lesson.summary}\n${lesson.durationLabel}',
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => _openLesson(lesson),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
