import 'package:flutter/material.dart';
import '../data/mock_data.dart';

// Карточка тренировочной сессии для дневника.
class SessionCard extends StatelessWidget {
  final WorkoutSession session;

  const SessionCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, size: 18, color: scheme.primary),
                const SizedBox(width: 8),
                Text(session.date, style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                Text('${session.durationMin} мин'),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: session.exercises
                  .map((e) => Chip(
                        label: Text(e),
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
            ),
            if (session.notes.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                session.notes,
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
