/// JSON dönüşümlerinin tek merkezde tutulduğu küçük yardımcılar.
String jsonText(Map<String, dynamic> source, String key) =>
    (source[key] ?? '').toString();

double jsonNumber(Map<String, dynamic> source, String key) {
  final value = source[key];
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}
