import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'result.dart';
import 'token_store.dart';
import 'api_message.dart';
import 'session_repository.dart';
import '../models/workout_session.dart';

// http-реализация интерфейса SessionRepository из L4 (CRUD тренировок).
class HttpSessionRepository implements SessionRepository {
  HttpSessionRepository(this.baseUrl, this.tokens, {this.onUnauthorized});
  final String baseUrl;
  final TokenStore tokens;
  final void Function()? onUnauthorized;
  static const _timeout = Duration(seconds: 8);

  Future<Map<String, String>> _headers() async => {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer ${await tokens.read() ?? ''}',
      };

  Future<String> _sessionDied() async {
    await tokens.clear();
    onUnauthorized?.call();
    return 'Сессия истекла — войдите снова';
  }

  @override
  Future<Result<List<WorkoutSession>>> fetchAll() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/workout-sessions?limit=100'), headers: await _headers())
          .timeout(_timeout);
      if (res.statusCode == 401) return Err(await _sessionDied());
      if (res.statusCode != 200) return Err(apiMessage(res));
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return Ok((data['items'] as List)
          .map((e) => WorkoutSession.fromJson(e as Map<String, dynamic>))
          .toList());
    } on SocketException {
      return const Err('Нет сети — повторите попытку');
    } on TimeoutException {
      return const Err('Сервер не отвечает');
    } on FormatException {
      return const Err('Ответ не тот, что обещан');
    } on TypeError {
      return const Err('Ответ не тот, что обещан');
    }
  }

  @override
  Future<Result<WorkoutSession>> fetchById(int id) async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/workout-sessions/$id'), headers: await _headers())
          .timeout(_timeout);
      if (res.statusCode == 401) return Err(await _sessionDied());
      if (res.statusCode != 200) return Err(apiMessage(res));
      return Ok(WorkoutSession.fromJson(jsonDecode(res.body) as Map<String, dynamic>));
    } on SocketException {
      return const Err('Нет сети — повторите попытку');
    } on TimeoutException {
      return const Err('Сервер не отвечает');
    } on FormatException {
      return const Err('Ответ не тот, что обещан');
    } on TypeError {
      return const Err('Ответ не тот, что обещан');
    }
  }

  @override
  Future<Result<WorkoutSession>> create(WorkoutSession session) async {
    try {
      final res = await http
          .post(Uri.parse('$baseUrl/workout-sessions'),
              headers: await _headers(), body: jsonEncode(session.toJson()))
          .timeout(_timeout);
      if (res.statusCode == 401) return Err(await _sessionDied());
      if (res.statusCode != 201) return Err(apiMessage(res)); // хороший статус 201
      return Ok(WorkoutSession.fromJson(jsonDecode(res.body) as Map<String, dynamic>));
    } on SocketException {
      return const Err('Нет сети — повторите попытку');
    } on TimeoutException {
      return const Err('Сервер не отвечает');
    } on FormatException {
      return const Err('Ответ не тот, что обещан');
    } on TypeError {
      return const Err('Ответ не тот, что обещан');
    }
  }

  @override
  Future<Result<WorkoutSession>> update(WorkoutSession session) async {
    try {
      final res = await http
          .put(Uri.parse('$baseUrl/workout-sessions/${session.id}'),
              headers: await _headers(), body: jsonEncode(session.toJson()))
          .timeout(_timeout);
      if (res.statusCode == 401) return Err(await _sessionDied());
      if (res.statusCode != 200) return Err(apiMessage(res));
      return Ok(WorkoutSession.fromJson(jsonDecode(res.body) as Map<String, dynamic>));
    } on SocketException {
      return const Err('Нет сети — повторите попытку');
    } on TimeoutException {
      return const Err('Сервер не отвечает');
    } on FormatException {
      return const Err('Ответ не тот, что обещан');
    } on TypeError {
      return const Err('Ответ не тот, что обещан');
    }
  }

  @override
  Future<Result<void>> delete(int id) async {
    try {
      final res = await http
          .delete(Uri.parse('$baseUrl/workout-sessions/$id'), headers: await _headers())
          .timeout(_timeout);
      if (res.statusCode == 401) return Err(await _sessionDied());
      if (res.statusCode != 204) return Err(apiMessage(res)); // 204: тело пустое
      return const Ok(null); // без jsonDecode на пустом теле
    } on SocketException {
      return const Err('Нет сети — повторите попытку');
    } on TimeoutException {
      return const Err('Сервер не отвечает');
    } on FormatException {
      return const Err('Ответ не тот, что обещан');
    } on TypeError {
      return const Err('Ответ не тот, что обещан');
    }
  }
}
