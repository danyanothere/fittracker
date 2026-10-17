import 'result.dart';
import 'mock_data.dart';
import 'exercise_repository.dart';
import '../models/exercise.dart';

// Mock-источник упражнений: память с повадками сети (задержка + авария).
class MockExerciseRepository implements ExerciseRepository {
  final List<Exercise> _items = List.of(mockExercises); // seed из прошлых лаб
  bool simulateError = false; // авария: включена -> любой вызов проваливается

  static const _latency = Duration(milliseconds: 800);
  static const _errNetwork = 'Сервер не отвечает — повторите попытку';

  @override
  Future<Result<List<Exercise>>> fetchAll() async {
    await Future.delayed(_latency); // сеть не отвечает мгновенно
    if (simulateError) return const Err(_errNetwork);
    return Ok(List.of(_items)); // копия — внутренность не отдаём из рук
  }

  @override
  Future<Result<Exercise>> fetchById(int id) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    final i = _items.indexWhere((e) => e.id == id);
    if (i == -1) return const Err('Упражнение не существует');
    return Ok(_items[i]);
  }
}
