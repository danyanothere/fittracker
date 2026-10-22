// SQLite setup. The database file is created automatically on first start.
//
// To add your own entity: add a CREATE TABLE below, then copy the pattern
// of lib/notes.dart for its routes.

import 'package:sqlite3/sqlite3.dart';

/// The single database connection, opened once at startup by [initDb].
late final Database db;

/// Opens (and creates, on first run) the database and its schema.
void initDb(String path) {
  db = sqlite3.open(path);
  db.execute('''
    CREATE TABLE IF NOT EXISTS users (
      id            INTEGER PRIMARY KEY AUTOINCREMENT,
      email         TEXT    NOT NULL UNIQUE,
      password_hash TEXT    NOT NULL,
      name          TEXT    NOT NULL,
      created_at    TEXT    NOT NULL
    );

    CREATE TABLE IF NOT EXISTS notes (
      id         INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id    INTEGER NOT NULL REFERENCES users (id),
      title      TEXT    NOT NULL,
      content    TEXT    NOT NULL DEFAULT '',
      created_at TEXT    NOT NULL
    );

    CREATE TABLE IF NOT EXISTS files (
      id         INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id    INTEGER NOT NULL REFERENCES users (id),
      name       TEXT    NOT NULL,
      mime_type  TEXT    NOT NULL,
      size       INTEGER NOT NULL,
      path       TEXT    NOT NULL,
      created_at TEXT    NOT NULL
    );

    -- FitTrack: справочник упражнений (общий для всех, только чтение)
    CREATE TABLE IF NOT EXISTS exercises (
      id           INTEGER PRIMARY KEY AUTOINCREMENT,
      name         TEXT    NOT NULL,
      muscle_group TEXT    NOT NULL,
      description  TEXT    NOT NULL DEFAULT '',
      technique    TEXT    NOT NULL DEFAULT ''
    );

    -- FitTrack: тренировки пользователя (на пользователя, полный CRUD)
    CREATE TABLE IF NOT EXISTS workout_sessions (
      id           INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id      INTEGER NOT NULL REFERENCES users (id),
      date         TEXT    NOT NULL,
      exercises    TEXT    NOT NULL DEFAULT '[]',
      duration_min INTEGER NOT NULL DEFAULT 0,
      notes        TEXT    NOT NULL DEFAULT '',
      created_at   TEXT    NOT NULL
    );
  ''');

  _seedExercises();
}

/// Дозасевает справочник упражнений: добавляет недостающие по имени
/// (идемпотентно — существующая база не теряется, просто пополняется).
void _seedExercises() {
  const seed = [
    ['Приседания со штангой', 'Ноги', 'Базовое упражнение на квадрицепсы, ягодицы и заднюю поверхность бедра.', 'Спина прямая, колени не выходят за носки, опускаться до параллели с полом.'],
    ['Жим штанги лёжа', 'Грудь', 'Основное упражнение для развития грудных мышц и трицепса.', 'Лопатки сведены, штанга опускается к нижней части груди, локти под 45 градусов.'],
    ['Становая тяга', 'Спина', 'Тяжёлое базовое упражнение на спину, ноги и хват.', 'Гриф ведём вдоль ног, спина ровная, таз и плечи поднимаются одновременно.'],
    ['Подтягивания', 'Спина', 'Упражнение с собственным весом на широчайшие мышцы спины.', 'Хват чуть шире плеч, подтягиваемся до подбородка, опускаемся под контролем.'],
    ['Жим гантелей стоя', 'Плечи', 'Развивает дельтовидные мышцы и стабилизаторы плеча.', 'Гантели выжимаем вверх без рывка, корпус держим напряжённым.'],
    ['Планка', 'Кор', 'Статическое упражнение на мышцы пресса и всего кора.', 'Тело в одну линию, таз не проваливается, дыхание ровное.'],
    ['Выпады с гантелями', 'Ноги', 'Прорабатывает каждую ногу отдельно, улучшает баланс.', 'Шаг вперёд, заднее колено почти касается пола, спина вертикально.'],
    ['Спринт 30 метров', 'Всё тело', 'Взрывное ускорение для футбольной подготовки.', 'Низкий старт, активная работа рук, полное выпрямление опорной ноги.'],
    ['Бёрпи', 'Всё тело', 'Кардио-упражнение на выносливость всего тела.', 'Присед, упор лёжа, отжимание, прыжок вверх без пауз.'],
    ['Скручивания на пресс', 'Кор', 'Изолированное упражнение на прямую мышцу живота.', 'Поясница прижата к полу, поднимаем корпус за счёт пресса, а не шеи.'],
    ['Отжимания от пола', 'Грудь', 'Базовое упражнение с собственным весом на грудь и трицепс.', 'Корпус прямой, локти близко к телу, опускаться до касания грудью пола.'],
    ['Жим ногами в тренажёре', 'Ноги', 'Нагружает квадрицепсы без осевой нагрузки на спину.', 'Колени не сводить, не разгибать полностью в верхней точке.'],
    ['Тяга верхнего блока', 'Спина', 'Альтернатива подтягиваниям на широчайшие.', 'Тянем к верху груди, лопатки сводим, корпус слегка отклонён.'],
    ['Разгибания на трицепс', 'Плечи', 'Изолированное упражнение на трицепс на блоке.', 'Локти прижаты к корпусу, двигается только предплечье.'],
    ['Подъём штанги на бицепс', 'Плечи', 'Базовое упражнение на бицепс.', 'Локти неподвижны, подъём без раскачки корпуса.'],
    ['Гиперэкстензия', 'Спина', 'Укрепляет разгибатели спины и ягодицы.', 'Поднимаемся до прямой линии, без переразгибания в пояснице.'],
    ['Махи гантелями в стороны', 'Плечи', 'Изоляция средней дельты.', 'Лёгкий вес, подъём до уровня плеч, без рывков.'],
    ['Тяга штанги в наклоне', 'Спина', 'Масса и толщина спины.', 'Спина прямая, тянем к поясу, лопатки сводим.'],
    ['Болгарские приседания', 'Ноги', 'Одноногий присед с упором задней ноги.', 'Колено передней ноги над стопой, корпус слегка вперёд.'],
    ['Подъём ног в висе', 'Кор', 'Нижний пресс на перекладине.', 'Без раскачки, поднимаем ноги за счёт пресса.'],
    ['Велосипед на пресс', 'Кор', 'Динамическое упражнение на косые мышцы живота.', 'Локоть к противоположному колену, поясница прижата.'],
    ['Прыжки на скакалке', 'Всё тело', 'Кардио и координация.', 'Прыжки невысокие, вращение кистями, приземление мягкое.'],
    ['Жим гантелей лёжа', 'Грудь', 'Больше амплитуда, чем у штанги.', 'Опускаем гантели до уровня груди, сводим в верхней точке.'],
    ['Шраги с гантелями', 'Плечи', 'Трапеции.', 'Поднимаем плечи вверх, без вращения, пауза в верхней точке.'],
  ];
  // множество уже существующих имён
  final existing = <String>{
    for (final r in db.select('SELECT name FROM exercises')) r['name'] as String,
  };
  for (final e in seed) {
    if (existing.contains(e[0])) continue;
    db.execute(
      'INSERT INTO exercises (name, muscle_group, description, technique) VALUES (?, ?, ?, ?)',
      e,
    );
  }
}

/// Current UTC time in ISO-8601, the format used for all timestamps.
String nowIso() => DateTime.now().toUtc().toIso8601String();
