import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/diary_model.dart';
import '../widgets/stat_tile.dart';
import '../widgets/label_value_row.dart';
import '../widgets/error_view.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  // зашитые значения столбиков (тренировок в неделю) — иллюстрация
  static const _weeks = [
    ('Нед 1', 3),
    ('Нед 2', 4),
    ('Нед 3', 2),
    ('Нед 4', 5),
  ];

  @override
  Widget build(BuildContext context) {
    final model = context.watch<DiaryModel>();

    final Widget body;
    if (model.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (model.error != null) {
      body = ErrorView(
        message: model.error!,
        onRetry: () => context.read<DiaryModel>().load(),
      );
    } else {
      body = _buildStats(context, model);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Статистика прогресса')),
      body: body,
    );
  }

  Widget _buildStats(BuildContext context, DiaryModel model) {
    final scheme = Theme.of(context).colorScheme;
    final hours = (model.totalMinutes / 60).toStringAsFixed(1);
    final perWeek = (model.count / 4).toStringAsFixed(1);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // агрегаты из модели: добавил/удалил сессию -> цифры меняются сами
        Row(
          children: [
            Expanded(child: StatTile(icon: Icons.fitness_center, value: '${model.count}', label: 'Тренировок')),
            const SizedBox(width: 12),
            Expanded(child: StatTile(icon: Icons.timer, value: '$hours ч', label: 'Всего времени')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: StatTile(icon: Icons.local_fire_department, value: '${model.avgMinutes} мин', label: 'В среднем')),
            const SizedBox(width: 12),
            Expanded(child: StatTile(icon: Icons.calendar_month, value: perWeek, label: 'В неделю')),
          ],
        ),
        const SizedBox(height: 24),
        Text('Тренировок по неделям', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
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
              children: [
                LabelValueRow(label: 'Всего минут', value: '${model.totalMinutes}'),
                const LabelValueRow(label: 'Любимая группа', value: 'Ноги'),
                const LabelValueRow(label: 'Текущая серия', value: '4 недели'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
