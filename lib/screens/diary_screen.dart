import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/diary_model.dart';
import '../widgets/session_card.dart';
import '../widgets/error_view.dart';

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

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
      body = ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: model.sessions.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final session = model.sessions[index];
          return Dismissible(
            key: ValueKey(session.id), // идентичность из данных, не UniqueKey
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete_outline),
            ),
            confirmDismiss: (_) => _confirmDelete(context, session.id),
            child: SessionCard(session: session),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Дневник тренировок'),
        actions: [
          // один живой угол — Consumer: badge со счётчиком сессий
          Consumer<DiaryModel>(
            builder: (context, m, child) => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Badge(
                label: Text('${m.count}'),
                child: child,
              ),
            ),
            child: const Icon(Icons.fitness_center),
          ),
        ],
      ),
      body: body,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/diary/new'),
        icon: const Icon(Icons.add),
        label: const Text('Сессия'),
      ),
    );
  }

  // диалог подтверждения -> удаление через модель -> исчезает из всех экранов
  Future<bool> _confirmDelete(BuildContext context, int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Удалить тренировку?'),
        content: const Text('Запись будет удалена из дневника.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Нет'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return false;
    final error = await context.read<DiaryModel>().remove(id);
    if (!context.mounted) return false;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return false; // авария: данные остаются
    }
    return true; // удалено из модели -> карточку можно убрать
  }
}
