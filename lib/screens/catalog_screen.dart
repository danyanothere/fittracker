import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/catalog_model.dart';
import '../models/exercise.dart';
import '../widgets/exercise_card.dart';
import '../widgets/error_view.dart';

// Каталог упражнений: данные с сервера, три состояния, поиск и пагинация на сервере.
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CatalogModel>();

    final Widget body;
    if (model.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (model.error != null) {
      body = ErrorView(
        message: model.error!,
        onRetry: () => context.read<CatalogModel>().load(),
      );
    } else {
      body = _list(context, model);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Каталог упражнений')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Поиск упражнения',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              // поиск уходит НА СЕРВЕР
              onSubmitted: (q) => context.read<CatalogModel>().load(search: q),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: muscleGroups.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final group = muscleGroups[index];
                final selected = group == 'Все'
                    ? model.search.isEmpty
                    : model.search == group;
                return FilterChip(
                  label: Text(group),
                  selected: selected,
                  // чип фильтрует через серверный поиск
                  onSelected: (_) => context
                      .read<CatalogModel>()
                      .load(search: group == 'Все' ? '' : group),
                );
              },
            ),
          ),
          Expanded(child: body),
        ],
      ),
    );
  }

  Widget _list(BuildContext context, CatalogModel model) {
    final items = model.exercises;
    return RefreshIndicator(
      onRefresh: () => context.read<CatalogModel>().load(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length + (model.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= items.length) {
            // хвост: просим следующую страницу и показываем маленький спиннер
            context.read<CatalogModel>().loadMore();
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final Exercise exercise = items[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ExerciseCard(
              exercise: exercise,
              onTap: () => context.push('/catalog/${exercise.id}'),
            ),
          );
        },
      ),
    );
  }
}
