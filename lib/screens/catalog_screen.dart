import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/catalog_model.dart';
import '../models/exercise.dart';
import '../widgets/exercise_card.dart';
import '../widgets/muscle_figure.dart';
import '../widgets/error_view.dart';

// группы, которые умеет подсвечивать силуэт (подмножество muscleGroups)
const _figureGroups = {'Ноги', 'Грудь', 'Спина', 'Плечи', 'Кор'};

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
              decoration: const InputDecoration(
                hintText: 'Поиск упражнения',
                prefixIcon: Icon(Icons.search),
              ),
              // поиск уходит НА СЕРВЕР
              onSubmitted: (q) => context.read<CatalogModel>().load(search: q),
            ),
          ),
          _muscleCard(context, model),
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

  // карточка с силуэтом тела: тап по мышце фильтрует каталог (тот же серверный поиск)
  Widget _muscleCard(BuildContext context, CatalogModel model) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final sel = _figureGroups.contains(model.search) ? model.search : null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 108,
                child: MuscleFigure(
                  selected: sel,
                  onSelect: (g) => context.read<CatalogModel>().load(search: g),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Группы мышц',
                        style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(
                      'Нажми на часть тела, чтобы показать нужные упражнения',
                      style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 14),
                    if (sel != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: scheme.primaryContainer,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(sel,
                            style: text.labelLarge
                                ?.copyWith(color: scheme.onPrimaryContainer)),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () => context.read<CatalogModel>().load(search: ''),
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text('Сбросить'),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ] else
                      Text('Группа не выбрана',
                          style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ),
        ),
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
