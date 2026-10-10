import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';

// Форма новой сессии: валидация локальная, данные никуда не сохраняются (контракт L3).
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
  bool _done = true;

  @override
  void dispose() {
    // кто создаёт контроллер, тот его освобождает (C6)
    _dateCtrl.dispose();
    _durationCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return; // ошибки уже на экране
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Сохранено: тренировка ${_dateCtrl.text.trim()}')),
    );
    context.pop(); // открыто push-ем -> закрывается pop-ом
  }

  @override
  Widget build(BuildContext context) {
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
              items: mockExercises
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
            SwitchListTile(
              title: const Text('Тренировка завершена'),
              value: _done,
              onChanged: (value) => setState(() => _done = value),
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
