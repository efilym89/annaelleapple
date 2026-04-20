import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../domain/repositories/learning_repository.dart';
import 'navigation/app_shell.dart';

class AnaelAcademyApp extends StatelessWidget {
  const AnaelAcademyApp({
    super.key,
    required this.learningRepository,
  });

  final LearningRepository learningRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anael Academy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      home: AppShell(learningRepository: learningRepository),
    );
  }
}
