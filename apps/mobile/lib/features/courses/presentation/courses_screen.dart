import 'package:flutter/material.dart';

import '../../../core/widgets/course_card.dart';
import '../../../core/widgets/state_message_view.dart';
import '../../../domain/entities/learning_models.dart';
import '../../../domain/repositories/learning_repository.dart';
import 'course_details_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({
    super.key,
    required this.learningRepository,
    required this.refreshToken,
    required this.onDataChanged,
  });

  final LearningRepository learningRepository;
  final int refreshToken;
  final VoidCallback onDataChanged;

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late Future<List<Course>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = widget.learningRepository.loadCourses();
  }

  @override
  void didUpdateWidget(covariant CoursesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.refreshToken != widget.refreshToken) {
      _reload();
    }
  }

  Future<void> _reload() async {
    setState(() {
      _coursesFuture = widget.learningRepository.loadCourses();
    });
  }

  Future<void> _openCourse(Course course) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => CourseDetailsScreen(
          learningRepository: widget.learningRepository,
          courseId: course.id,
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

    return FutureBuilder<List<Course>>(
      future: _coursesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return StateMessageView(
            icon: Icons.error_outline_rounded,
            title: 'Не удалось загрузить курсы',
            description:
                'Проверьте локальные данные и повторите попытку синхронизации.',
            actionLabel: 'Повторить',
            onAction: _reload,
          );
        }

        final courses = snapshot.data ?? <Course>[];
        if (courses.isEmpty) {
          return StateMessageView(
            icon: Icons.library_books_outlined,
            title: 'Курсы не найдены',
            description:
                'После синхронизации `storage` здесь появятся реальные блоки обучения.',
            actionLabel: 'Обновить',
            onAction: _reload,
          );
        }

        return RefreshIndicator(
          onRefresh: _reload,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
            children: [
              Text(
                'Курсы',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Реальные учебные блоки из локального storage, готовые к дальнейшему переходу на API.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ...courses.map(
                (course) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: CourseCard(
                    course: course,
                    onTap: () => _openCourse(course),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
