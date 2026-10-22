import 'dart:convert';
import 'package:http/http.dart' as http;

// Вскрывает конверт ошибки {"error":{"code","message"}} и переводит code
// в русское сообщение для экрана. Английский message на экран не попадает.
String apiMessage(http.Response res) {
  try {
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final error = body['error'] as Map<String, dynamic>;
    switch (error['code'] as String) {
      case 'VALIDATION_ERROR':
        return 'Отправленные данные недействительны';
      case 'UNAUTHORIZED':
        return 'Неверный email или пароль';
      case 'EMAIL_TAKEN':
        return 'Аккаунт с этим email уже существует';
      case 'NOT_FOUND':
        return 'Запись не существует';
      default:
        return 'Ошибка сервера (${error['code']})';
    }
  } on FormatException {
    return 'Ошибка сервера (${res.statusCode})'; // тело вне контракта (HTML от прокси)
  } on TypeError {
    return 'Ошибка сервера (${res.statusCode})';
  }
}
