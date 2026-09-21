import 'package:flutter/material.dart';
import 'catalog_screen.dart';
import 'diary_screen.dart';
import 'stats_screen.dart';
import 'profile_screen.dart';

// Обёртка с NavigationBar. Хранит только индекс выбранной вкладки (L2).
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _screens = [
    CatalogScreen(),
    DiaryScreen(),
    StatsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Каталог'),
          NavigationDestination(icon: Icon(Icons.book_outlined), label: 'Дневник'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Статистика'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Профиль'),
        ],
      ),
    );
  }
}
