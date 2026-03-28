import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

@lazySingleton
class DatabaseHelper {
  Database? _database;

  DatabaseHelper();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'chat_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 세션 테이블 생성
    await db.execute('''
      CREATE TABLE sessions(
        id TEXT PRIMARY KEY,
        title TEXT,
        createdAt TEXT,
        lastMessageAt TEXT
      )
    ''');

    // 메시지 테이블 생성
    await db.execute('''
      CREATE TABLE messages(
        id TEXT PRIMARY KEY,
        sessionId TEXT,
        text TEXT,
        isUser INTEGER,
        timestamp TEXT,
        FOREIGN KEY (sessionId) REFERENCES sessions (id) ON DELETE CASCADE
      )
    ''');
  }

  /// 테스트를 위해 데이터베이스를 초기화하는 기능 (필요시)
  Future<void> clearAll() async {
    final db = await database;
    await db.delete('messages');
    await db.delete('sessions');
  }
}
