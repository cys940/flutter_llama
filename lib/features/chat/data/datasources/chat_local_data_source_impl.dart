import 'package:sqflite/sqflite.dart';
import 'package:injectable/injectable.dart';
import 'package:local_ai_chat/core/database/database_helper.dart';
import '../../domain/entities/session_entity.dart';
import '../../domain/entities/message_entity.dart';
import 'chat_local_data_source.dart';

@LazySingleton(as: ChatLocalDataSource)
class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final DatabaseHelper dbHelper;

  ChatLocalDataSourceImpl(this.dbHelper);

  @override
  Future<void> createOrUpdateSession(SessionEntity session) async {
    final db = await dbHelper.database;
    await db.insert(
      'sessions',
      SessionEntity.toMap(session),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    final db = await dbHelper.database;
    await db.delete('sessions', where: 'id = ?', whereArgs: [sessionId]);
    await db.delete('messages', where: 'sessionId = ?', whereArgs: [sessionId]);
  }

  @override
  Future<List<MessageEntity>> getMessages(String sessionId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'sessionId = ?',
      whereArgs: [sessionId],
      orderBy: 'timestamp ASC',
    );

    return List.generate(maps.length, (i) => MessageEntity.fromMap(maps[i]));
  }

  @override
  Future<List<SessionEntity>> getSessions() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sessions',
      orderBy: 'lastMessageAt DESC',
    );

    return List.generate(maps.length, (i) => SessionEntity.fromMap(maps[i]));
  }

  @override
  Future<void> saveMessage(String sessionId, MessageEntity message) async {
    final db = await dbHelper.database;
    await db.insert('messages', MessageEntity.toMap(message, sessionId));

    // 세션의 마지막 메시지 시간 업데이트
    await db.update(
      'sessions',
      {'lastMessageAt': message.timestamp.toIso8601String()},
      where: 'id = ?',
      whereArgs: [sessionId],
    );
  }
}
