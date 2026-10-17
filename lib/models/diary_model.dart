import 'package:flutter/foundation.dart';
import '../data/result.dart';
import '../data/session_repository.dart';
import 'workout_session.dart';

// Состояние журнала тренировок: триада + мутации через хранилище + агрегаты.
class DiaryModel extends ChangeNotifier {
  DiaryModel(this._repository);
  final SessionRepository _repository;

  bool _loading = false;
  String? _error;
  List<WorkoutSession> _sessions = const [];

  bool get isLoading => _loading;
  String? get error => _error;
  List<WorkoutSession> get sessions => List.unmodifiable(_sessions);

  // агрегаты читает экран статистики — одна весть обновляет и его
  int get count => _sessions.length;
  int get totalMinutes => _sessions.fold(0, (sum, s) => sum + s.durationMin);
  int get avgMinutes =>
      _sessions.isEmpty ? 0 : (totalMinutes / _sessions.length).round();

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    switch (await _repository.fetchAll()) {
      case Ok(:final value):
        _sessions = value;
      case Err(:final msg):
        _error = msg;
    }
    _loading = false;
    notifyListeners();
  }

  // null при успехе, сообщение при провале — та же логика, что у validator
  Future<String?> add(WorkoutSession draft) async {
    switch (await _repository.create(draft)) {
      case Ok(:final value):
        _sessions = [value, ..._sessions]; // с id от хранилища
        notifyListeners(); // список, статистика, badge — узнают все
        return null;
      case Err(:final msg):
        return msg; // состояние нетронуто
    }
  }

  Future<String?> remove(int id) async {
    switch (await _repository.delete(id)) {
      case Ok():
        _sessions = _sessions.where((s) => s.id != id).toList();
        notifyListeners();
        return null;
      case Err(:final msg):
        return msg;
    }
  }
}
