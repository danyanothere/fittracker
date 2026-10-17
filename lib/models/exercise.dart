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
}

const muscleGroups = ['Все', 'Ноги', 'Грудь', 'Спина', 'Плечи', 'Кор', 'Всё тело'];
