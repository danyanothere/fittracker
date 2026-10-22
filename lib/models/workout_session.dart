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

  // граница JSON (L5)
  factory WorkoutSession.fromJson(Map<String, dynamic> j) => WorkoutSession(
        id: j['id'] as int,
        date: j['date'] as String? ?? '',
        exercises:
            (j['exercises'] as List? ?? const []).map((e) => e as String).toList(),
        durationMin: (j['durationMin'] as num?)?.toInt() ?? 0,
        notes: j['notes'] as String? ?? '',
      );

  // без id — идентичность даёт сервер
  Map<String, dynamic> toJson() => {
        'date': date,
        'exercises': exercises,
        'durationMin': durationMin,
        'notes': notes,
      };
}
