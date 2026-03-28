import 'package:flutter_test/flutter_test.dart';
import 'package:local_ai_chat/core/database/database_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() {
  setUpAll(() {
    final getIt = GetIt.instance;
    if (!getIt.isRegistered<Talker>()) {
      getIt.registerSingleton<Talker>(Talker());
    }
  });

  group('DatabaseHelper TDD tests', () {
    test('DatabaseHelper should be instantiated', () {
      final dbHelper = DatabaseHelper();
      expect(dbHelper, isNotNull);
    });
  });
}
