import 'result.dart';
import '../models/exercise.dart';

// Контракт: ЧТО можно просить про упражнения, а не КАК. Упражнения только читаются.
abstract class ExerciseRepository {
  Future<Result<List<Exercise>>> fetchAll();
  Future<Result<Exercise>> fetchById(int id);
}
