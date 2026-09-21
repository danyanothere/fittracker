import 'package:flutter/material.dart';
import '../widgets/stat_tile.dart';
import '../widgets/label_value_row.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  // зашитые значения для недельных столбиков (тренировок в неделю)
  static const _weeks = [
    ('Нед 1', 3),
    ('Нед 2', 4),
    ('Нед 3', 2),
    ('Нед 4', 5),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Статистика прогресса')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Row(
            children: [
              Expanded(child: StatTile(icon: Icons.fitness_center, value: '14', label: 'Тренировок')),
              SizedBox(width: 12),
              Expanded(child: StatTile(icon: Icons.timer, value: '12 ч', label: 'Всего времени')),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(child: StatTile(icon: Icons.local_fire_department, value: '54 мин', label: 'В среднем')),
              SizedBox(width: 12),
              Expanded(child: StatTile(icon: Icons.calendar_month, value: '3,5', label: 'В неделю')),
            ],
          ),
          const SizedBox(height: 24),
          Text('Тренировок по неделям', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _weeks.map((w) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('${w.$2}'),
                    const SizedBox(height: 4),
                    Container(
                      width: 32,
                      height: w.$2 * 26.0,
                      decoration: BoxDecoration(
                        color: scheme.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(w.$1, style: TextStyle(color: scheme.onSurfaceVariant)),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: const [
                  LabelValueRow(label: 'Любимая группа', value: 'Ноги'),
                  LabelValueRow(label: 'Самая долгая', value: '70 мин'),
                  LabelValueRow(label: 'Текущая серия', value: '4 недели'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
