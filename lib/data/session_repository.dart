import 'result.dart';
import '../models/workout_session.dart';

// Контракт сессий — пишущая сущность темы (CRUD). На L5 ляжет на REST один-к-одному.
abstract class SessionRepository {
  Future<Result<List<WorkoutSession>>> fetchAll(); // GET /sessions
  Future<Result<WorkoutSession>> fetchById(int id); // GET /sessions/{id}
  Future<Result<WorkoutSession>> create(WorkoutSession session); // POST /sessions
  Future<Result<WorkoutSession>> update(WorkoutSession session); // PUT /sessions/{id}
  Future<Result<void>> delete(int id); // DELETE /sessions/{id}
}
