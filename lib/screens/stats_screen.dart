import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/diary_model.dart';
import '../widgets/stat_tile.dart';
import '../widgets/label_value_row.dart';
import '../widgets/weekly_goal_ring.dart';
import '../widgets/training_heatmap.dart';
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
        // цель недели (кольцо с анимацией) + серия тренировок
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                WeeklyGoalRing(
                  done: model.thisWeekCount,
                  goal: DiaryModel.weeklyGoal,
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.local_fire_department, color: scheme.primary),
                          const SizedBox(width: 8),
                          Text('${model.weekStreak} нед',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('серия тренировок подряд',
                          style: TextStyle(color: scheme.onSurfaceVariant)),
                      const SizedBox(height: 12),
                      Text(
                        '${model.thisWeekCount} из ${DiaryModel.weeklyGoal} на этой неделе',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
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
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Тренировок по неделям',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 18),
                SizedBox(
                  height: 180,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _weeks.map((w) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${w.$2}',
                              style: TextStyle(
                                  color: scheme.onSurfaceVariant, fontSize: 12)),
                          const SizedBox(height: 6),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: w.$2 * 24.0),
                            duration: const Duration(milliseconds: 700),
                            curve: Curves.easeOutCubic,
                            builder: (context, h, _) => Container(
                              width: 30,
                              height: h,
                              decoration: BoxDecoration(
                                color: scheme.primary,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(w.$1,
                              style: TextStyle(
                                  color: scheme.onSurfaceVariant, fontSize: 12)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Карта активности',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                TrainingHeatmap(days: model.trainingDays),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
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
