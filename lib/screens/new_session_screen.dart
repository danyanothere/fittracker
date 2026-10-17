import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/catalog_model.dart';
import '../models/diary_model.dart';
import '../models/workout_session.dart';

// Форма новой сессии: валидный submit ПИШЕТ в модель через repository.
class NewSessionScreen extends StatefulWidget {
  const NewSessionScreen({super.key});

  @override
  State<NewSessionScreen> createState() => _NewSessionScreenState();
}

class _NewSessionScreenState extends State<NewSessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String? _exercise;

  @override
  void dispose() {
    _dateCtrl.dispose();
    _durationCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return; // валидация L3, нетронута
    final draft = WorkoutSession(
      id: 0, // временный id — настоящую идентичность даст хранилище
      date: _dateCtrl.text.trim(),
      exercises: [_exercise!],
      durationMin: int.parse(_durationCtrl.text),
      notes: _notesCtrl.text.trim(),
    );
    final error = await context.read<DiaryModel>().add(draft);
    if (!mounted) return; // экран может умереть, пока "запрос" летит
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return; // данные остаются в полях
    }
    context.pop(); // список позади УЖЕ вырос — notifyListeners известил его
  }

  @override
  Widget build(BuildContext context) {
    final exercises = context.watch<CatalogModel>().exercises;
    return Scaffold(
      appBar: AppBar(title: const Text('Новая тренировка')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _dateCtrl,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Дата',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Укажите дату' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _exercise,
              decoration: const InputDecoration(
                labelText: 'Упражнение',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.fitness_center),
              ),
              items: exercises
                  .map((e) => DropdownMenuItem(value: e.name, child: Text(e.name)))
                  .toList(),
              onChanged: (value) => setState(() => _exercise = value),
              validator: (value) => value == null ? 'Выберите упражнение' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _durationCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: false),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Длительность, мин',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.timer_outlined),
              ),
              validator: (value) {
                final minutes = int.tryParse(value ?? '');
                if (minutes == null) return 'Введите число';
                if (minutes <= 0) return 'Длительность должна быть больше нуля';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Заметки',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _save,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Сохранить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
