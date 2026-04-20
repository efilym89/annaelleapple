import 'package:flutter/material.dart';

import '../../../core/widgets/course_card.dart';
import '../../../core/widgets/metric_card.dart';
import '../../../core/widgets/state_message_view.dart';
import '../../../domain/entities/learning_models.dart';
import '../../../domain/repositories/learning_repository.dart';
import '../../courses/presentation/course_details_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.learningRepository,
    required this.refreshToken,
    required this.onDataChanged,
  });

  final LearningRepository learningRepository;
  final int refreshToken;
  final VoidCallback onDataChanged;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<ProfileSummary> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = widget.learningRepository.loadProfileSummary();
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.refreshToken != widget.refreshToken) {
      _reload();
    }
  }

  Future<void> _reload() async {
    setState(() {
      _profileFuture = widget.learningRepository.loadProfileSummary();
    });
  }

  Future<void> _resetProgress() async {
    await widget.learningRepository.resetProgress();
    widget.onDataChanged();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Прогресс сброшен')),
    );
    await _reload();
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

    return FutureBuilder<ProfileSummary>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return StateMessageView(
            icon: Icons.person_off_rounded,
            title: 'Профиль недоступен',
            description:
                'Не удалось собрать локальную сводку прогресса. Попробуйте обновить данные.',
            actionLabel: 'Повторить',
            onAction: _reload,
          );
        }

        final profile = snapshot.data;
        if (profile == null) {
          return StateMessageView(
            icon: Icons.person_outline_rounded,
            title: 'Нет данных профиля',
            description:
                'После появления курсов и прогресса здесь отобразится персональная сводка.',
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(
                          Icons.person_rounded,
                          size: 34,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Профиль сотрудника',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              profile.completionPercentLabel,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      label: 'Курсы',
                      value: '${profile.totalCourses}',
                      caption: '${profile.completedCourses} завершено',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MetricCard(
                      label: 'Уроки',
                      value: '${profile.completedLessons}',
                      caption: 'из ${profile.totalLessons}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              MetricCard(
                label: 'Общий прогресс',
                value: profile.completionPercentLabel,
                caption: 'Сводка перенесена в профиль вместо отдельной вкладки.',
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Мои курсы',
                    style: theme.textTheme.titleLarge,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _resetProgress,
                    child: const Text('Сбросить прогресс'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...profile.courses.map(
                (course) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
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
