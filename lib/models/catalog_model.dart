import 'package:flutter/foundation.dart';
import '../data/result.dart';
import '../data/exercise_repository.dart';
import 'exercise.dart';

// Состояние каталога упражнений + триада loading/data/error. Без widget-ов.
class CatalogModel extends ChangeNotifier {
  CatalogModel(this._repository); // DI: хранилище приходит в конструктор
  final ExerciseRepository _repository; // тип — ИНТЕРФЕЙС, а не mock

  bool _loading = false;
  String? _error;
  List<Exercise> _exercises = const [];

  bool get isLoading => _loading;
  String? get error => _error;
  List<Exercise> get exercises => List.unmodifiable(_exercises);

  Exercise? byId(int id) {
    for (final e in _exercises) {
      if (e.id == id) return e;
    }
    return null;
  }

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners(); // подписанные экраны входят в состояние "грузится"
    switch (await _repository.fetchAll()) {
      case Ok(:final value):
        _exercises = value;
      case Err(:final msg):
        _error = msg;
    }
    _loading = false;
    notifyListeners(); // …и выходят: с данными или с ошибкой, никогда молча
  }
}
