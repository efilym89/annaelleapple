import 'package:flutter/material.dart';

import '../../domain/repositories/learning_repository.dart';
import '../../features/courses/presentation/courses_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.learningRepository,
  });

  final LearningRepository learningRepository;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  int _refreshToken = 0;

  void _handleDataChanged() {
    setState(() {
      _refreshToken += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        learningRepository: widget.learningRepository,
        refreshToken: _refreshToken,
        onDataChanged: _handleDataChanged,
      ),
      CoursesScreen(
        learningRepository: widget.learningRepository,
        refreshToken: _refreshToken,
        onDataChanged: _handleDataChanged,
      ),
      ProfileScreen(
        learningRepository: widget.learningRepository,
        refreshToken: _refreshToken,
        onDataChanged: _handleDataChanged,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_rounded),
            label: 'Курсы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
