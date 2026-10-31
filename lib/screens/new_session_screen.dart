import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/catalog_model.dart';
import '../models/diary_model.dart';
import '../models/workout_session.dart';

const _months = [
  'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
  'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
];
String _fmtDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

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

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() => _dateCtrl.text = _fmtDate(picked));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final draft = WorkoutSession(
      id: 0, // временный id — настоящую идентичность даст сервер
      date: _dateCtrl.text.trim(),
      exercises: [_exercise!],
      durationMin: int.parse(_durationCtrl.text),
      notes: _notesCtrl.text.trim(),
    );
    final error = await context.read<DiaryModel>().add(draft);
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    context.pop(); // список позади уже вырос через notifyListeners
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
            // поле только для чтения: тап открывает календарь
            TextFormField(
              controller: _dateCtrl,
              readOnly: true,
              onTap: _pickDate,
              decoration: const InputDecoration(
                labelText: 'Дата',
                prefixIcon: Icon(Icons.calendar_today),
                suffixIcon: Icon(Icons.expand_more),
              ),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Выберите дату' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _exercise,
              decoration: const InputDecoration(
                labelText: 'Упражнение',
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
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _save,
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
