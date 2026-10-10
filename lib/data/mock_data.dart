// Модели данных темы FitTrack и зашитые mock-данные

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
}

const muscleGroups = ['Все', 'Ноги', 'Грудь', 'Спина', 'Плечи', 'Кор', 'Всё тело'];

const mockExercises = [
  Exercise(
    id: 1,
    name: 'Приседания со штангой',
    muscleGroup: 'Ноги',
    description: 'Базовое упражнение на квадрицепсы, ягодицы и заднюю поверхность бедра.',
    technique: 'Спина прямая, колени не выходят за носки, опускаться до параллели с полом.',
  ),
  Exercise(
    id: 2,
    name: 'Жим штанги лёжа',
    muscleGroup: 'Грудь',
    description: 'Основное упражнение для развития грудных мышц и трицепса.',
    technique: 'Лопатки сведены, штанга опускается к нижней части груди, локти под 45 градусов.',
  ),
  Exercise(
    id: 3,
    name: 'Становая тяга',
    muscleGroup: 'Спина',
    description: 'Тяжёлое базовое упражнение на спину, ноги и хват.',
    technique: 'Гриф ведём вдоль ног, спина ровная, таз и плечи поднимаются одновременно.',
  ),
  Exercise(
    id: 4,
    name: 'Подтягивания',
    muscleGroup: 'Спина',
    description: 'Упражнение с собственным весом на широчайшие мышцы спины.',
    technique: 'Хват чуть шире плеч, подтягиваемся до подбородка, опускаемся под контролем.',
  ),
  Exercise(
    id: 5,
    name: 'Жим гантелей стоя',
    muscleGroup: 'Плечи',
    description: 'Развивает дельтовидные мышцы и стабилизаторы плеча.',
    technique: 'Гантели выжимаем вверх без рывка, корпус держим напряжённым.',
  ),
  Exercise(
    id: 6,
    name: 'Планка',
    muscleGroup: 'Кор',
    description: 'Статическое упражнение на мышцы пресса и всего кора.',
    technique: 'Тело в одну линию, таз не проваливается, дыхание ровное.',
  ),
  Exercise(
    id: 7,
    name: 'Выпады с гантелями',
    muscleGroup: 'Ноги',
    description: 'Прорабатывает каждую ногу отдельно, улучшает баланс.',
    technique: 'Шаг вперёд, заднее колено почти касается пола, спина вертикально.',
  ),
  Exercise(
    id: 8,
    name: 'Спринт 30 метров',
    muscleGroup: 'Всё тело',
    description: 'Взрывное ускорение для футбольной подготовки.',
    technique: 'Низкий старт, активная работа рук, полное выпрямление опорной ноги.',
  ),
  Exercise(
    id: 9,
    name: 'Бёрпи',
    muscleGroup: 'Всё тело',
    description: 'Кардио-упражнение на выносливость всего тела.',
    technique: 'Присед, упор лёжа, отжимание, прыжок вверх без пауз.',
  ),
  Exercise(
    id: 10,
    name: 'Скручивания на пресс',
    muscleGroup: 'Кор',
    description: 'Изолированное упражнение на прямую мышцу живота.',
    technique: 'Поясница прижата к полу, поднимаем корпус за счёт пресса, а не шеи.',
  ),
];

const mockSessions = [
  WorkoutSession(
    id: 1,
    date: '20 сентября 2026',
    exercises: ['Приседания со штангой', 'Выпады с гантелями', 'Планка'],
    durationMin: 65,
    notes: 'День ног, вес в приседе увеличил на 5 кг.',
  ),
  WorkoutSession(
    id: 2,
    date: '18 сентября 2026',
    exercises: ['Спринт 30 метров', 'Бёрпи'],
    durationMin: 40,
    notes: 'Функциональная тренировка перед игрой.',
  ),
  WorkoutSession(
    id: 3,
    date: '16 сентября 2026',
    exercises: ['Жим штанги лёжа', 'Жим гантелей стоя', 'Скручивания на пресс'],
    durationMin: 55,
    notes: 'Верх тела, чувствовал себя бодро.',
  ),
  WorkoutSession(
    id: 4,
    date: '14 сентября 2026',
    exercises: ['Становая тяга', 'Подтягивания'],
    durationMin: 50,
    notes: 'Спина, техника становой стала стабильнее.',
  ),
  WorkoutSession(
    id: 5,
    date: '12 сентября 2026',
    exercises: ['Спринт 30 метров', 'Выпады с гантелями', 'Планка'],
    durationMin: 45,
    notes: 'Скоростная работа, ноги забились.',
  ),
  WorkoutSession(
    id: 6,
    date: '10 сентября 2026',
    exercises: ['Приседания со штангой', 'Жим штанги лёжа', 'Бёрпи'],
    durationMin: 70,
    notes: 'Полноценная общая тренировка.',
  ),
];
