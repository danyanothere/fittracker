import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// обёртка с постоянными вкладками. индекс знает router, поэтому виджет StatelessWidget
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
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
