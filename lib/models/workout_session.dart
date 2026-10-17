// Доменная модель тренировочной сессии.
class WorkoutSession {
  final int id;
  final String date;
  final List<String> exercises;
  final int durationMin;
  final String notes;

  const WorkoutSession({
    required this.id,
    required this.date,
    required this.exercises,
    required this.durationMin,
    required this.notes,
  });

  // "та же сессия, другая идентичность" — id даёт хранилище при create
  WorkoutSession copyWith({int? id}) => WorkoutSession(
        id: id ?? this.id,
        date: date,
        exercises: exercises,
        durationMin: durationMin,
        notes: notes,
      );
}
