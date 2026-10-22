// Workout sessions: главная CRUD-сущность темы, на пользователя.
// Скопировано с шаблона notes.dart: список с пагинацией/поиском,
// создание с валидацией (400), get/put/delete с 404.

import 'dart:convert';
import 'dart:math';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sqlite3/sqlite3.dart';

import 'auth.dart';
import 'db.dart';
import 'errors.dart';

Map<String, Object?> _toJson(Row row) => {
      'id': row['id'],
      'date': row['date'],
      'exercises': jsonDecode(row['exercises'] as String),
      'durationMin': row['duration_min'],
      'notes': row['notes'],
      'createdAt': row['created_at'],
    };

Row? _find(int userId, String? idParam) {
  final id = int.tryParse(idParam ?? '');
  if (id == null) return null;
  final rows = db.select(
    'SELECT * FROM workout_sessions WHERE id = ? AND user_id = ?',
    [id, userId],
  );
  return rows.isEmpty ? null : rows.first;
}

List<String> _exercisesField(Map<String, dynamic> body) {
  final raw = body['exercises'];
  if (raw is! List) return [];
  return raw.whereType<String>().toList();
}

/// GET /workout-sessions?page=1&limit=20&search= -> {items, page, limit, total}
Future<Response> listSessions(Request request) async {
  final query = request.url.queryParameters;
  final page = max(int.tryParse(query['page'] ?? '') ?? 1, 1);
  final limit = (int.tryParse(query['limit'] ?? '') ?? 20).clamp(1, 100);
  final search = query['search'] ?? '';

  const where = 'user_id = ? AND (date LIKE ? OR notes LIKE ? OR exercises LIKE ?)';
  final args = [currentUserId(request), '%$search%', '%$search%', '%$search%'];

  final total =
      db.select('SELECT COUNT(*) AS n FROM workout_sessions WHERE $where', args)
          .first['n'] as int;
  final rows = db.select(
    'SELECT * FROM workout_sessions WHERE $where ORDER BY id DESC LIMIT ? OFFSET ?',
    [...args, limit, (page - 1) * limit],
  );

  return jsonResponse({
    'items': rows.map(_toJson).toList(),
    'page': page,
    'limit': limit,
    'total': total,
  });
}

/// POST /workout-sessions {date, exercises, durationMin, notes} -> 201
Future<Response> createSession(Request request) async {
  final body = await readJsonBody(request);
  if (body == null) return validationError('Body must be a JSON object');
  final date = stringField(body, 'date');
  if (date == null) return validationError('date is required');
  final exercises = _exercisesField(body);
  final duration = (body['durationMin'] as num?)?.toInt() ?? 0;
  final notes = body['notes'] is String ? body['notes'] as String : '';

  db.execute(
    'INSERT INTO workout_sessions (user_id, date, exercises, duration_min, notes, created_at) '
    'VALUES (?, ?, ?, ?, ?, ?)',
    [currentUserId(request), date, jsonEncode(exercises), duration, notes, nowIso()],
  );
  final row = _find(currentUserId(request), '${db.lastInsertRowId}')!;
  return jsonResponse(_toJson(row), status: 201);
}

/// GET /workout-sessions/{id} -> 200 | 404
Future<Response> getSession(Request request) async {
  final row = _find(currentUserId(request), request.params['id']);
  if (row == null) return notFound('Session not found');
  return jsonResponse(_toJson(row));
}

/// PUT /workout-sessions/{id} -> 200 | 404
Future<Response> updateSession(Request request) async {
  final row = _find(currentUserId(request), request.params['id']);
  if (row == null) return notFound('Session not found');

  final body = await readJsonBody(request);
  if (body == null) return validationError('Body must be a JSON object');
  final date = stringField(body, 'date');
  if (date == null) return validationError('date is required');
  final exercises = _exercisesField(body);
  final duration = (body['durationMin'] as num?)?.toInt() ?? 0;
  final notes = body['notes'] is String ? body['notes'] as String : '';

  db.execute(
    'UPDATE workout_sessions SET date = ?, exercises = ?, duration_min = ?, notes = ? WHERE id = ?',
    [date, jsonEncode(exercises), duration, notes, row['id']],
  );
  final updated = _find(currentUserId(request), '${row['id']}')!;
  return jsonResponse(_toJson(updated));
}

/// DELETE /workout-sessions/{id} -> 204 | 404
Future<Response> deleteSession(Request request) async {
  final row = _find(currentUserId(request), request.params['id']);
  if (row == null) return notFound('Session not found');
  db.execute('DELETE FROM workout_sessions WHERE id = ?', [row['id']]);
  return Response(204);
}
