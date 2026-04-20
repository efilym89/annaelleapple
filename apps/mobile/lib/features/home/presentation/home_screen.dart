import 'package:flutter/material.dart';

import '../../../core/widgets/course_card.dart';
import '../../../core/widgets/feed_card.dart';
import '../../../core/widgets/state_message_view.dart';
import '../../../domain/entities/learning_models.dart';
import '../../../domain/repositories/learning_repository.dart';
import '../../courses/presentation/course_details_screen.dart';
import '../../lesson/presentation/lesson_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.learningRepository,
    required this.refreshToken,
    required this.onDataChanged,
  });

  final LearningRepository learningRepository;
  final int refreshToken;
  final VoidCallback onDataChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<DashboardSnapshot> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = widget.learningRepository.loadDashboard();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.refreshToken != widget.refreshToken) {
      _reload();
    }
  }

  Future<void> _reload() async {
    setState(() {
      _dashboardFuture = widget.learningRepository.loadDashboard();
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

  Future<void> _openLesson(Lesson lesson) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => LessonScreen(
          learningRepository: widget.learningRepository,
          courseId: lesson.courseId,
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

    return FutureBuilder<DashboardSnapshot>(
      future: _dashboardFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return StateMessageView(
            icon: Icons.cloud_off_rounded,
            title: 'Не удалось загрузить главную',
            description:
                'Проверьте локальный манифест контента и попробуйте обновить данные.',
            actionLabel: 'Повторить',
            onAction: _reload,
          );
        }

        final dashboard = snapshot.data;
        if (dashboard == null) {
          return StateMessageView(
            icon: Icons.inbox_rounded,
            title: 'Данные пока не готовы',
            description:
                'После синхронизации локального storage здесь появятся курсы и материалы.',
            actionLabel: 'Обновить',
            onAction: _reload,
          );
        }

        return RefreshIndicator(
          onRefresh: _reload,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Добро пожаловать',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Anael Academy',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Главная страница объединяет обучение, новости компании и полезные внутренние материалы.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              if (dashboard.continueLesson != null) ...[
                const SizedBox(height: 24),
                _SectionHeader(
                  title: 'Продолжить обучение',
                  actionLabel: 'Открыть',
                  onAction: () => _openLesson(dashboard.continueLesson!),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dashboard.continueLesson!.title,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          dashboard.continueLesson!.summary,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: () => _openLesson(dashboard.continueLesson!),
                          icon: const Icon(Icons.play_circle_outline_rounded),
                          label: const Text('Перейти к уроку'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              const _SectionHeader(title: 'Новости компании'),
              const SizedBox(height: 12),
              ...dashboard.companyNews.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FeedCard(
                    item: item,
                    icon: Icons.campaign_rounded,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const _SectionHeader(title: 'Полезные материалы'),
              const SizedBox(height: 12),
              ...dashboard.usefulMaterials.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FeedCard(
                    item: item,
                    icon: Icons.article_outlined,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const _SectionHeader(title: 'Мои курсы'),
              const SizedBox(height: 12),
              ...dashboard.courses.map(
                (course) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CourseCard(
                    course: course,
                    onTap: () => _openCourse(course),
                    showDescription: false,
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleLarge,
          ),
        ),
        if (actionLabel != null && onAction != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}
