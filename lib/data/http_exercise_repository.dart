import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'result.dart';
import 'token_store.dart';
import 'api_message.dart';
import 'exercise_repository.dart';
import '../models/exercise.dart';

// http-реализация интерфейса ExerciseRepository из L4. Справочник, только чтение.
class HttpExerciseRepository implements ExerciseRepository {
  HttpExerciseRepository(this.baseUrl, this.tokens, {this.onUnauthorized});
  final String baseUrl;
  final TokenStore tokens;
  final void Function()? onUnauthorized; // решает корень: назад на login
  static const _timeout = Duration(seconds: 8);

  Future<Map<String, String>> _headers() async => {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer ${await tokens.read() ?? ''}',
      };

  // 401 = пропуск умер: token выбрасывается, корень навигирует на login
  Future<String> _sessionDied() async {
    await tokens.clear();
    onUnauthorized?.call();
    return 'Сессия истекла — войдите снова';
  }

  @override
  Future<Result<List<Exercise>>> fetchAll({int page = 1, int limit = 20, String? search}) async {
    try {
      // адрес получает query-параметры: пагинация и поиск идут НА СЕРВЕР
      final uri = Uri.parse('$baseUrl/exercises').replace(queryParameters: {
        'page': '$page',
        'limit': '$limit',
        if (search != null && search.isNotEmpty) 'search': search,
      });
      final res = await http.get(uri, headers: await _headers()).timeout(_timeout);
      if (res.statusCode == 401) return Err(await _sessionDied());
      if (res.statusCode != 200) return Err(apiMessage(res)); // слой 2
      final data = jsonDecode(res.body) as Map<String, dynamic>; // конверт
      return Ok((data['items'] as List)
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
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
  Future<Result<Exercise>> fetchById(int id) async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/exercises/$id'), headers: await _headers())
          .timeout(_timeout);
      if (res.statusCode == 401) return Err(await _sessionDied());
      if (res.statusCode != 200) return Err(apiMessage(res));
      return Ok(Exercise.fromJson(jsonDecode(res.body) as Map<String, dynamic>));
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
