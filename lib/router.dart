import 'package:go_router/go_router.dart';
import 'screens/login_screen.dart';
import 'screens/catalog_screen.dart';
import 'screens/exercise_detail_screen.dart';
import 'screens/diary_screen.dart';
import 'screens/new_session_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/app_shell.dart';

// карта маршрутов приложения: login снаружи, разделы в shell-е с вкладками
final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/catalog',
              builder: (context, state) => const CatalogScreen(),
              routes: [
                GoRoute(
                  path: ':id', // полный адрес: /catalog/7
                  builder: (context, state) {
                    final id = int.parse(state.pathParameters['id']!);
                    return ExerciseDetailScreen(id: id);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/diary',
              builder: (context, state) => const DiaryScreen(),
              routes: [
                GoRoute(
                  path: 'new', // полный адрес: /diary/new
                  builder: (context, state) => const NewSessionScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/stats',
              builder: (context, state) => const StatsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
