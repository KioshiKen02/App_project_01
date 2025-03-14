import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper1 {
  static final DatabaseHelper1 instance = DatabaseHelper1._init();
  static Database? _database;

  DatabaseHelper1._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('events.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        title TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertEvent(String date, String title) async {
    final db = await database;
    return await db.insert('events', {'date': date, 'title': title});
  }

  Future<List<Map<String, dynamic>>> getEventsByDate(String date) async {
    final db = await database;
    return await db.query('events', where: 'date = ?', whereArgs: [date]);
  }

  Future<int> updateEvent(int id, String newTitle) async {
    final db = await database;
    return await db.update('events', {'title': newTitle}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteEvent(int id) async {
    final db = await database;
    return await db.delete('events', where: 'id = ?', whereArgs: [id]);
  }
}
