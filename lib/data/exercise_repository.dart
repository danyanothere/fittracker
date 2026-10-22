import 'result.dart';
import '../models/exercise.dart';

// Контракт: ЧТО можно просить про упражнения. Интерфейс вырос совместимо (L5):
// опциональные именованные параметры не ломают вызовы, написанные на L4.
abstract class ExerciseRepository {
  Future<Result<List<Exercise>>> fetchAll({int page = 1, int limit = 20, String? search});
  Future<Result<Exercise>> fetchById(int id);
}
