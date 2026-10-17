import 'result.dart';
import 'mock_data.dart';
import 'session_repository.dart';
import '../models/workout_session.dart';

// Mock-источник сессий: память + задержка + авария + выдача id хранилищем.
class MockSessionRepository implements SessionRepository {
  final List<WorkoutSession> _items = List.of(mockSessions);
  int _nextId = 1000; // выше любого id из seed-а
  bool simulateError = false;

  static const _latency = Duration(milliseconds: 800);
  static const _errNetwork = 'Сервер не отвечает — повторите попытку';

  @override
  Future<Result<List<WorkoutSession>>> fetchAll() async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    return Ok(List.of(_items));
  }

  @override
  Future<Result<WorkoutSession>> fetchById(int id) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    final i = _items.indexWhere((s) => s.id == id);
    if (i == -1) return const Err('Тренировка не существует');
    return Ok(_items[i]);
  }

  @override
  Future<Result<WorkoutSession>> create(WorkoutSession session) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    final created = session.copyWith(id: _nextId++); // id даёт ХРАНИЛИЩЕ
    _items.insert(0, created);
    return Ok(created);
  }

  @override
  Future<Result<WorkoutSession>> update(WorkoutSession session) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    final i = _items.indexWhere((s) => s.id == session.id);
    if (i == -1) return const Err('Тренировка не существует');
    _items[i] = session;
    return Ok(session);
  }

  @override
  Future<Result<void>> delete(int id) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    if (!_items.any((s) => s.id == id)) return const Err('Тренировка не существует');
    _items.removeWhere((s) => s.id == id);
    return const Ok(null); // "удалил, отдать нечего" — 204 из C8
  }
}
