import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'router.dart';
import 'data/api_config.dart';
import 'data/token_store.dart';
import 'data/auth_api.dart';
import 'data/http_exercise_repository.dart';
import 'data/http_session_repository.dart';
import 'models/catalog_model.dart';
import 'models/diary_model.dart';

// Корень композиции: ЗДЕСЬ (и только здесь) выбирается источник данных.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // prefs до runApp
  final tokens = TokenStore();
  final loggedIn = await tokens.read() != null; // запуск решает по token-у

  router = GoRouter(
    initialLocation: loggedIn ? '/catalog' : '/login',
    routes: buildRoutes(),
  );

  // 401 -> login, в одном месте
  void onUnauthorized() => router.go('/login');
  final exerciseRepo = HttpExerciseRepository(apiBase, tokens, onUnauthorized: onUnauthorized);
  final sessionRepo = HttpSessionRepository(apiBase, tokens, onUnauthorized: onUnauthorized);

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthApi>(create: (_) => AuthApi(apiBase, tokens)),
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
