import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'router.dart';
import 'data/mock_exercise_repository.dart';
import 'data/mock_session_repository.dart';
import 'models/catalog_model.dart';
import 'models/diary_model.dart';

void main() {
  // корень композиции: ЗДЕСЬ (и только здесь) выбирается источник данных
  final exerciseRepo = MockExerciseRepository(); // на L5: http-вариант — и всё
  final sessionRepo = MockSessionRepository();
  runApp(
    MultiProvider(
      providers: [
        // леса демонстрации аварии (Задание 7) — исчезают на L5 вместе с mock
        Provider<MockExerciseRepository>.value(value: exerciseRepo),
        Provider<MockSessionRepository>.value(value: sessionRepo),
        ChangeNotifierProvider(create: (_) => CatalogModel(exerciseRepo)..load()),
        ChangeNotifierProvider(create: (_) => DiaryModel(sessionRepo)..load()),
      ],
      child: const FitTrackApp(),
    ),
  );
}

class FitTrackApp extends StatelessWidget {
  const FitTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FitTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.w600),
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
