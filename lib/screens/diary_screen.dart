import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';
import '../widgets/session_card.dart';

// Дневник тренировок: список сессий в обратном хронологическом порядке.
class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Дневник тренировок')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: mockSessions.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) => SessionCard(session: mockSessions[index]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/diary/new'),
        icon: const Icon(Icons.add),
        label: const Text('Сессия'),
      ),
    );
  }
}
