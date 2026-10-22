// Exercises: справочник упражнений, общий для всех (только чтение).

import 'dart:math';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sqlite3/sqlite3.dart';

import 'db.dart';
import 'errors.dart';

Map<String, Object?> _toJson(Row row) => {
      'id': row['id'],
      'name': row['name'],
      'muscleGroup': row['muscle_group'],
      'description': row['description'],
      'technique': row['technique'],
    };

Row? _find(String? idParam) {
  final id = int.tryParse(idParam ?? '');
  if (id == null) return null;
  final rows = db.select('SELECT * FROM exercises WHERE id = ?', [id]);
  return rows.isEmpty ? null : rows.first;
}

/// GET /exercises?page=1&limit=20&search= -> {items, page, limit, total}
Future<Response> listExercises(Request request) async {
  final query = request.url.queryParameters;
  final page = max(int.tryParse(query['page'] ?? '') ?? 1, 1);
  final limit = (int.tryParse(query['limit'] ?? '') ?? 20).clamp(1, 100);
  final search = query['search'] ?? '';

  const where = '(name LIKE ? OR muscle_group LIKE ?)';
  final args = ['%$search%', '%$search%'];
  final total =
      db.select('SELECT COUNT(*) AS n FROM exercises WHERE $where', args)
          .first['n'] as int;
  final rows = db.select(
    'SELECT * FROM exercises WHERE $where ORDER BY id ASC LIMIT ? OFFSET ?',
    [...args, limit, (page - 1) * limit],
  );

  return jsonResponse({
    'items': rows.map(_toJson).toList(),
    'page': page,
    'limit': limit,
    'total': total,
  });
}

/// GET /exercises/{id} -> 200 exercise | 404
Future<Response> getExercise(Request request) async {
  final row = _find(request.params['id']);
  if (row == null) return notFound('Exercise not found');
  return jsonResponse(_toJson(row));
}
