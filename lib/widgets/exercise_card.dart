import 'package:flutter/material.dart';
import '../data/mock_data.dart';

// Карточка упражнения. Используется в каталоге и в форме новой сессии.
class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback? onTap;

  const ExerciseCard({super.key, required this.exercise, this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: scheme.primaryContainer,
          child: Text(
            exercise.name[0],
            style: TextStyle(color: scheme.onPrimaryContainer),
          ),
        ),
        title: Text(exercise.name),
        subtitle: Text(exercise.muscleGroup),
        trailing: onTap == null ? null : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
