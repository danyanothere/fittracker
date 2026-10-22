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

/// Заполняет справочник упражнений один раз, если он пуст.
void _seedExercises() {
  final count = db.select('SELECT COUNT(*) AS n FROM exercises').first['n'] as int;
  if (count > 0) return;
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
  ];
  for (final e in seed) {
    db.execute(
      'INSERT INTO exercises (name, muscle_group, description, technique) VALUES (?, ?, ?, ?)',
      e,
    );
  }
}

/// Current UTC time in ISO-8601, the format used for all timestamps.
String nowIso() => DateTime.now().toUtc().toIso8601String();
