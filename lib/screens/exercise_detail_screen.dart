import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/catalog_model.dart';
import '../widgets/label_value_row.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final int id;

  const ExerciseDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CatalogModel>();
    final exercise = model.byId(id); // ищем через модель, а не через mock

    if (exercise == null) {
      // у null два смысла: список ещё грузится или id реально нет
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: model.isLoading
              ? const CircularProgressIndicator()
              : const Text('Упражнение не существует'),
        ),
      );
    }

    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(exercise.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.fitness_center, size: 80, color: scheme.onPrimaryContainer),
          ),
          const SizedBox(height: 16),
          Text(exercise.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Chip(label: Text(exercise.muscleGroup)),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Описание', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(exercise.description),
                  const Divider(height: 24),
                  Text('Техника', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(exercise.technique),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  LabelValueRow(label: 'Группа мышц', value: exercise.muscleGroup),
                  LabelValueRow(label: 'Оборудование', value: 'Штанга / гантели'),
                  LabelValueRow(label: 'Уровень', value: 'Средний'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
