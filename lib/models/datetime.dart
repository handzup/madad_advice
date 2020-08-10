import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

class CustomDateTimeConverter implements JsonConverter<DateTime, String> {
  const CustomDateTimeConverter();

  @override
  DateTime fromJson(String json) {
    DateFormat format = new DateFormat("dd.MM.yyyy hh:mm:ss");

    return format.parse(json);
  }

  @override
  String toJson(DateTime json) => json.toIso8601String();
}
