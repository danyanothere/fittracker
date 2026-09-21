import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/session_card.dart';
import 'new_session_screen.dart';

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
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) => SessionCard(session: mockSessions[index]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NewSessionScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Сессия'),
      ),
    );
  }
}
