import 'package:flutter/material.dart';

// Хитмап тренировок в стиле гитхаба: столбцы недель, строки дней недели.
// Яркость клетки растёт с числом тренировок в этот день.
class TrainingHeatmap extends StatelessWidget {
  final Map<DateTime, int> days; // день -> число тренировок
  final int weeks;

  const TrainingHeatmap({super.key, required this.days, this.weeks = 16});

  Color _cellColor(ColorScheme scheme, int count, bool future) {
    if (future) return Colors.transparent;
    if (count <= 0) return scheme.surfaceContainerHighest;
    if (count == 1) return scheme.primary.withValues(alpha: 0.35);
    if (count == 2) return scheme.primary.withValues(alpha: 0.65);
    return scheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // понедельник самой ранней показываемой недели
    final currentMonday = today.subtract(Duration(days: today.weekday - 1));
    final start = currentMonday.subtract(Duration(days: (weeks - 1) * 7));

    const cell = 13.0;
    const gap = 4.0;

    final columns = <Widget>[];
    for (var w = 0; w < weeks; w++) {
      final cells = <Widget>[];
      for (var d = 0; d < 7; d++) {
        final date = start.add(Duration(days: w * 7 + d));
        final future = date.isAfter(today);
        final count = days[date] ?? 0;
        cells.add(Padding(
          padding: const EdgeInsets.only(bottom: gap),
          child: Container(
            width: cell,
            height: cell,
            decoration: BoxDecoration(
              color: _cellColor(scheme, count, future),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ));
      }
      columns.add(Padding(
        padding: const EdgeInsets.only(right: gap),
        child: Column(children: cells),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true, // свежие недели сразу видны справа
          child: Row(children: columns),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text('меньше', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
            const SizedBox(width: 6),
            for (final a in const [0.0, 0.35, 0.65, 1.0])
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Container(
                  width: cell,
                  height: cell,
                  decoration: BoxDecoration(
                    color: a == 0.0
                        ? scheme.surfaceContainerHighest
                        : scheme.primary.withValues(alpha: a),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            const SizedBox(width: 2),
            Text('больше', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
          ],
        ),
      ],
    );
  }
}
