import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/catalog_model.dart';
import '../models/exercise.dart';
import '../widgets/exercise_card.dart';
import '../widgets/error_view.dart';

// Каталог упражнений: данные из модели, три состояния loading/data/error.
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CatalogModel>(); // watch в build (C7)

    final Widget body;
    if (model.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (model.error != null) {
      body = ErrorView(
        message: model.error!,
        onRetry: () => context.read<CatalogModel>().load(), // read: действие
      );
    } else {
      body = Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск упражнения',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: muscleGroups.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) => FilterChip(
                label: Text(muscleGroups[index]),
                selected: index == 0,
                onSelected: (_) {},
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              // потянуть вниз -> перезагрузка через модель
              onRefresh: () => context.read<CatalogModel>().load(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: model.exercises.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final Exercise exercise = model.exercises[index];
                  return ExerciseCard(
                    exercise: exercise,
                    onTap: () => context.push('/catalog/${exercise.id}'),
                  );
                },
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Каталог упражнений')),
      body: body,
    );
  }
}
