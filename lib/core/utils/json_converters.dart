import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

/// SQLite에서 bool(0/1)과 Dart의 bool 간 변환을 담당합니다.
class BoolIntConverter implements JsonConverter<bool, dynamic> {
  const BoolIntConverter();

  @override
  bool fromJson(dynamic json) {
    if (json is int) return json == 1;
    if (json is bool) return json;
    return false;
  }

  @override
  int toJson(bool object) => object ? 1 : 0;
}

/// SQLite에서 TEXT(JSON String)와 Dart 객체 간 변환을 담당합니다.
class JsonMapConverter<T> implements JsonConverter<T?, dynamic> {
  const JsonMapConverter(this.fromJsonFactory);

  final T Function(Map<String, dynamic> json) fromJsonFactory;

  @override
  T? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is String) {
      if (json.isEmpty) return null;
      try {
        final Map<String, dynamic> decoded = jsonDecode(json);
        return fromJsonFactory(decoded);
      } catch (e) {
        return null;
      }
    }
    if (json is Map<String, dynamic>) {
      return fromJsonFactory(json);
    }
    return null;
  }

  @override
  dynamic toJson(T? object) {
    if (object == null) return null;
    return jsonEncode(object);
  }
}
