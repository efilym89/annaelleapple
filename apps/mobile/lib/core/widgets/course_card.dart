import 'package:flutter/material.dart';

import '../../domain/entities/learning_models.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
    this.showDescription = true,
  });

  final Course course;
  final VoidCallback onTap;
  final bool showDescription;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                course.title,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                course.subtitle,
                style: theme.textTheme.bodyMedium,
              ),
              if (showDescription) ...[
                const SizedBox(height: 12),
                Text(
                  course.description,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(label: Text('${course.lessonCount} уроков')),
                  Chip(label: Text(course.totalDurationLabel)),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: course.progressValue,
                minHeight: 8,
                borderRadius: BorderRadius.circular(999),
                backgroundColor:
                    theme.colorScheme.primary.withValues(alpha: 0.12),
              ),
              const SizedBox(height: 8),
              Text(
                course.progressLabel,
                style: theme.textTheme.bodyMedium,
              ),
              if (course.nextLesson != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Следующий урок',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  course.nextLesson!.title,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
