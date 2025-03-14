import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton pattern: Single database instance for the entire app
  static Database? _database;

  // Initialize and return SQLite database instance with schema
  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  // Create initial database structure with users table
  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_database.db');

    return await openDatabase(
        path,
        version: 2,
        onCreate: (Database db, int version) async {
          await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY,
            email TEXT,
            password TEXT,
            hashed_password TEXT,
            username TEXT,
            created_at TEXT,
            uploaded INTEGER DEFAULT 0
          )''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute('ALTER TABLE users ADD COLUMN uploaded INTEGER DEFAULT 0');
          }
        }
    );
  }

  // Save both plain and hashed passwords
  Future<void> saveUserCredentials(String email, String plainPassword, String? hashedPassword) async {
    final db = await database;
    await db.insert(
      'users',
      {
        'email': email,
        'password': plainPassword,         // For auto-fill
        'hashed_password': hashedPassword  // For server sync
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Get plain password for auto-fill
  Future<Map<String, String>?> getSavedCredentials() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
        'users',
        columns: ['email', 'password'], // Only retrieve plain password
        limit: 1
    );
    if (results.isNotEmpty) {
      return {
        'email': results.first['email'],
        'password': results.first['password'] // This will be the plain password
      };
    }
    return null;
  }

  // Check if stored credentials match for offline login
  Future<bool> verifyLocalCredentials(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }

  // Insert or update user data in local database
  Future<void> saveUser(Map<String, dynamic> userData) async {
    final db = await database;
    await db.insert(
      'users',
      userData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Delete all user records from database
  Future<void> clearUsers() async {
    final db = await database;
    await db.delete('users');
  }

  // Update user's password in local storage
  Future<void> updateUserPassword(String email, String newPassword) async {
    final db = await database;
    await db.update(
      'users',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  // Get first user record (current logged-in user)
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query('users', limit: 1);
    return results.isNotEmpty ? results.first : null;
  }

  // Update email and username for user profile
  Future<void> updateUserProfile(String email, String username) async {
    final db = await database;
    await db.update(
      'users',
      {
        'email': email,
        'username': username,
      },
      where: 'email = ?',
      whereArgs: [email],
    );
  }


  // Get all users from local database
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }

  // Replace local users with server data in single transaction
  Future<void> syncUsers(List<dynamic> serverUsers) async {
    final db = await database;
    await db.transaction((txn) async {
      // Clear existing data first
      await txn.delete('users');

      // Insert new data from server
      for (var serverUser in serverUsers) {
        await txn.insert(
            'users',
            serverUser,
            conflictAlgorithm: ConflictAlgorithm.replace  // Handles ID conflicts
        );
      }
    });
  }


  // Get users pending upload to server
  Future<List<Map<String, dynamic>>> getPendingUploads() async {
    final db = await database;
    return db.query('users', where: 'uploaded = ?', whereArgs: [0]);
  }

  // Mark users as uploaded to server
  Future<void> markUploaded() async {
    final db = await database;
    await db.update('users', {'uploaded': 1});
  }

  // Remove specific user by ID
  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Store last synchronization timestamp
  Future<void> updateLastSyncTimestamp(int timestamp) async {
    final db = await database;
    await db.rawUpdate('''
    CREATE TABLE IF NOT EXISTS sync_info (
      id INTEGER PRIMARY KEY,
      last_sync INTEGER
    )
  ''');

    await db.rawUpdate('''
    INSERT OR REPLACE INTO sync_info (id, last_sync)
    VALUES (1, ?)
  ''', [timestamp]);
  }

  // Retrieve last synchronization timestamp
  Future<int?> getLastSyncTimestamp() async {
    final db = await database;
    await db.rawUpdate('''
    CREATE TABLE IF NOT EXISTS sync_info (
      id INTEGER PRIMARY KEY,
      last_sync INTEGER
    )
  ''');

    final result = await db.query('sync_info', where: 'id = 1');
    return result.isNotEmpty ? result.first['last_sync'] as int : null;
  }



}
