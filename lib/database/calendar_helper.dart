import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper1 {
  static final DatabaseHelper1 _instance = DatabaseHelper1._internal();
  static Database? _database;

  factory DatabaseHelper1() {
    return _instance;
  }

  DatabaseHelper1._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'events.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        date TEXT,
        isCompleted INTEGER
      )
    ''');
  }

  // Insert an event
  Future<int> insertEvent(Map<String, dynamic> event) async {
    Database db = await database;
    return await db.insert('events', event);
  }

  // Get all events
  Future<List<Map<String, dynamic>>> getEvents() async {
    Database db = await database;
    return await db.query('events');
  }

  // Update an event
  Future<int> updateEvent(Map<String, dynamic> event) async {
    try {
      Database db = await database;
      debugPrint('Updating event in database: $event');
      return await db.update(
        'events',
        event,
        where: 'id = ?',
        whereArgs: [event['id']],
      );
    } catch (e) {
      debugPrint('Error in updateEvent: $e');
      rethrow; // Rethrow the error to propagate it
    }
  }

  // Delete an event
  Future<int> deleteEvent(int id) async {
    Database db = await database;
    return await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}