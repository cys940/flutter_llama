import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../di/injection.dart';

@lazySingleton
class DatabaseHelper {
  final Talker _talker = getIt<Talker>();
  Database? _database;

  DatabaseHelper();

  Future<Database> get database async {
    if (_database != null) return _database!;
    try {
      _database = await _initDatabase();
      return _database!;
    } catch (e, st) {
      _talker.handle(e, st, '[DatabaseHelper] Failed to initialize database');
      rethrow; // Re-throwing so the provider can catch it and update the UI state
    }
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'chat_database.db');
    _talker.debug('[DatabaseHelper] Initializing database at $path');
    
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        // SQLite는 기본적으로 외래 키를 비활성화합니다.
        // ON DELETE CASCADE 등 외래 키 제약이 실제로 동작하려면 반드시 활성화해야 합니다.
        await db.execute('PRAGMA foreign_keys = ON');
        _talker.debug('[DatabaseHelper] Database opened successfully (foreign_keys=ON)');
      },
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    _talker.debug('[DatabaseHelper] Upgrading database from $oldVersion to $newVersion');
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE sessions ADD COLUMN isMeeting INTEGER DEFAULT 0');
      await db.execute('ALTER TABLE sessions ADD COLUMN meetingMetadata TEXT');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    _talker.debug('[DatabaseHelper] Creating tables for version $version');
    
    try {
      // 세션 테이블 생성
      await db.execute('''
        CREATE TABLE sessions(
          id TEXT PRIMARY KEY,
          title TEXT,
          createdAt TEXT,
          lastMessageAt TEXT,
          isMeeting INTEGER DEFAULT 0,
          meetingMetadata TEXT
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
    } catch (e, st) {
       _talker.handle(e, st, '[DatabaseHelper] Error during table creation');
       rethrow;
    }
  }

  /// 테스트를 위해 데이터베이스를 초기화하는 기능 (필요시)
  Future<void> clearAll() async {
    try {
      final db = await database;
      await db.delete('messages');
      await db.delete('sessions');
    } catch (e, st) {
      _talker.handle(e, st, '[DatabaseHelper] Error clearing database');
    }
  }
}
