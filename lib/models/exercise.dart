// Доменная модель упражнения. Переживает L5 (mock умирает, модель — нет).
class Exercise {
  final int id;
  final String name;
  final String muscleGroup;
  final String description;
  final String technique;

  const Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.description,
    required this.technique,
  });

  // граница JSON: разбор ответа сервера (L5)
  factory Exercise.fromJson(Map<String, dynamic> j) => Exercise(
        id: j['id'] as int,
        name: j['name'] as String,
        muscleGroup: j['muscleGroup'] as String? ?? '',
        description: j['description'] as String? ?? '',
        technique: j['technique'] as String? ?? '',
      );
}

const muscleGroups = ['Все', 'Ноги', 'Грудь', 'Спина', 'Плечи', 'Кор', 'Всё тело'];
