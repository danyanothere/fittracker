import 'package:flutter/material.dart';
import '../data/mock_data.dart';

// Форма новой сессии. На L2 это макет: без валидации и без сохранения.
class NewSessionScreen extends StatelessWidget {
  const NewSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Новая тренировка')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const TextField(
            decoration: InputDecoration(
              labelText: 'Дата',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.calendar_today),
            ),
          ),
          const SizedBox(height: 16),
          Text('Упражнения', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: mockExercises
                .map((e) => FilterChip(
                      label: Text(e.name),
                      selected: false,
                      onSelected: (_) {},
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          const TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Длительность, мин',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.timer_outlined),
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Заметки',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Тренировка завершена'),
            value: true,
            onChanged: (_) {},
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Сохранить'),
            ),
          ),
        ],
      ),
    );
  }
}
