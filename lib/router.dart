import 'package:go_router/go_router.dart';
import 'screens/login_screen.dart';
import 'screens/catalog_screen.dart';
import 'screens/exercise_detail_screen.dart';
import 'screens/diary_screen.dart';
import 'screens/new_session_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/app_shell.dart';

// router создаётся в main() — initialLocation решает по наличию token-а (L5)
late GoRouter router;

// маршруты L3 без изменений; login снаружи shell-а, разделы внутри
List<RouteBase> buildRoutes() => [
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
                    path: ':id',
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
                    path: 'new',
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
    ];
