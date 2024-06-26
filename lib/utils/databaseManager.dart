import 'package:anzen/models/vaultitem.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {
  static final DatabaseManager instance = DatabaseManager._init();
  static Database? _database;

  DatabaseManager._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users_store.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE mainvault (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        username TEXT,
        password TEXT,
        website TEXT,
        notes TEXT,
        tags TEXT
      )
''');
  }

  /// Insert
  Future<int> insertVaultItem(VaultItem vaultItem) async {
    final db = await instance.database;
    return await db.insert('mainvault', vaultItem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<VaultItem>> getMainVaultContent() async {
    final db = await instance.database;
    final maps = await db.query('mainvault');
    return List.generate(maps.length, (i) {
      return VaultItem.fromMap(maps[i]);
    });
  }

  Future<int> updatePassword(VaultItem vaultItem) async {
    final db = await instance.database;
    return await db.update(
      'mainvault',
      vaultItem.toMap(),
      where: 'id = ?',
      whereArgs: [vaultItem.id],
    );
  }

  Future<int> deleteVaultItem(int id) async {
    final db = await instance.database;
    return await db.delete(
      'mainvault',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
