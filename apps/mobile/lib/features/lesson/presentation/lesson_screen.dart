import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/widgets/state_message_view.dart';
import '../../../domain/entities/learning_models.dart';
import '../../../domain/repositories/learning_repository.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({
    super.key,
    required this.learningRepository,
    required this.courseId,
    required this.lessonId,
    required this.onDataChanged,
  });

  final LearningRepository learningRepository;
  final String courseId;
  final String lessonId;
  final VoidCallback onDataChanged;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late Future<Lesson> _lessonFuture;
  bool _savingProgress = false;

  @override
  void initState() {
    super.initState();
    _lessonFuture =
        widget.learningRepository.loadLesson(widget.courseId, widget.lessonId);
  }

  Future<void> _reload() async {
    setState(() {
      _lessonFuture =
          widget.learningRepository.loadLesson(widget.courseId, widget.lessonId);
    });
  }

  Future<void> _markCompleted(Lesson lesson) async {
    if (lesson.isCompleted) {
      return;
    }

    setState(() {
      _savingProgress = true;
    });

    try {
      await widget.learningRepository.markLessonCompleted(lesson.id);
      widget.onDataChanged();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Прогресс сохранен'),
        ),
      );
      await _reload();
    } finally {
      if (mounted) {
        setState(() {
          _savingProgress = false;
        });
      }
    }
  }

  Future<void> _openExternalUri(String rawUri) async {
    final uri = Uri.tryParse(rawUri);
    if (uri == null) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось открыть материал'),
        ),
      );
      return;
    }

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Открытие файла недоступно на текущем устройстве'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Урок'),
      ),
      body: FutureBuilder<Lesson>(
        future: _lessonFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const StateMessageView(
              icon: Icons.error_outline_rounded,
              title: 'Не удалось открыть урок',
              description:
                  'Проверьте локальный манифест или попробуйте открыть урок позже.',
            );
          }

          final lesson = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (lesson.durationLabel != null)
                            Chip(label: Text(lesson.durationLabel!)),
                          Chip(
                            label: Text(
                              lesson.isCompleted
                                  ? 'Изучено'
                                  : 'В процессе',
                            ),
                          ),
                          Chip(label: Text(lesson.status)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        lesson.description,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 18),
                      FilledButton.icon(
                        onPressed: _savingProgress
                            ? null
                            : () => _markCompleted(lesson),
                        icon: _savingProgress
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Icon(
                                lesson.isCompleted
                                    ? Icons.check_circle_rounded
                                    : Icons.task_alt_rounded,
                              ),
                        label: Text(
                          lesson.isCompleted
                              ? 'Урок уже отмечен'
                              : 'Отметить как изученный',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Видео',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              if (lesson.video != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lesson.video!.title,
                          style: theme.textTheme.titleMedium,
                        ),
                        if (lesson.video!.durationLabel != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Длительность: ${lesson.video!.durationLabel}',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                        const SizedBox(height: 14),
                        FilledButton.tonalIcon(
                          onPressed: () => _openExternalUri(lesson.video!.uri),
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('Открыть видео'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                const StateMessageView(
                  icon: Icons.play_circle_outline_rounded,
                  title: 'Видео не найдено',
                  description:
                      'Для этого урока пока нет локального видеоисточника.',
                ),
              const SizedBox(height: 20),
              Text(
                'Материалы',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              if (lesson.materials.isEmpty)
                const StateMessageView(
                  icon: Icons.description_outlined,
                  title: 'Дополнительные материалы не найдены',
                  description:
                      'Когда презентация или вложения появятся в storage, они автоматически отобразятся здесь.',
                )
              else
                ...lesson.materials.map(
                  (material) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        leading: const Icon(Icons.slideshow_rounded),
                        title: Text(material.title),
                        subtitle: Text(material.type),
                        trailing: const Icon(Icons.open_in_new_rounded),
                        onTap: () => _openExternalUri(material.uri),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Следующий шаг MVP',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'В текущем локальном storage нет банка вопросов, поэтому экран урока пока завершает сценарий изучения материалов. После подключения backend здесь можно добавить тест и оценивание без переработки UI-слоя.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
