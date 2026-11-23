// Единый формат русской даты: и печать, и разбор в одном месте.
// Храним дату строкой ("23 октября 2026"), поэтому нужен обратный парсер
// для статистики (хитмап, серия недель).
const ruMonths = [
  'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
  'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря',
];

String formatRuDate(DateTime d) => '${d.day} ${ruMonths[d.month - 1]} ${d.year}';

// null, если строка не в нашем формате (старые записи от руки не ломают экран)
DateTime? parseRuDate(String raw) {
  final parts = raw.trim().split(RegExp(r'\s+'));
  if (parts.length != 3) return null;
  final day = int.tryParse(parts[0]);
  final month = ruMonths.indexOf(parts[1]) + 1; // 0 -> не найдено -> month 0
  final year = int.tryParse(parts[2]);
  if (day == null || month == 0 || year == null) return null;
  return DateTime(year, month, day);
}
