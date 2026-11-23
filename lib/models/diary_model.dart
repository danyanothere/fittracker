import 'package:flutter/foundation.dart';
import '../data/result.dart';
import '../data/session_repository.dart';
import '../utils/ru_date.dart';
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

  // --- агрегаты для визуальной статистики (кольцо цели, серия, хитмап) ---
  static const weeklyGoal = 4; // цель тренировок в неделю

  // день (без времени) -> сколько тренировок. Нераспознанные даты пропускаем.
  Map<DateTime, int> get trainingDays {
    final map = <DateTime, int>{};
    for (final s in _sessions) {
      final d = parseRuDate(s.date);
      if (d == null) continue;
      final key = DateTime(d.year, d.month, d.day);
      map[key] = (map[key] ?? 0) + 1;
    }
    return map;
  }

  static DateTime _mondayOf(DateTime d) {
    final day = DateTime(d.year, d.month, d.day);
    return day.subtract(Duration(days: day.weekday - 1));
  }

  // тренировок на текущей неделе (пн..вс)
  int get thisWeekCount {
    final monday = _mondayOf(DateTime.now());
    final nextMonday = monday.add(const Duration(days: 7));
    var n = 0;
    trainingDays.forEach((d, c) {
      if (!d.isBefore(monday) && d.isBefore(nextMonday)) n += c;
    });
    return n;
  }

  // сколько недель подряд (включая текущую) была хотя бы одна тренировка
  int get weekStreak {
    final weeks = trainingDays.keys.map(_mondayOf).toSet();
    if (weeks.isEmpty) return 0;
    var streak = 0;
    var cursor = _mondayOf(DateTime.now());
    while (weeks.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 7));
    }
    return streak;
  }

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
