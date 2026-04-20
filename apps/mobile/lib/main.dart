import 'package:flutter/material.dart';

import 'app/app.dart';
import 'data/datasources/local_content_data_source.dart';
import 'data/datasources/local_progress_data_source.dart';
import 'data/repositories/local_learning_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final learningRepository = LocalLearningRepository(
    contentDataSource: LocalContentDataSource(),
    progressDataSource: LocalProgressDataSource(),
  );

  runApp(
    AnaelAcademyApp(learningRepository: learningRepository),
  );
}
