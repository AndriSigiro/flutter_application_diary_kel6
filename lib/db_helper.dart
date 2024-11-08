import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  // Mendapatkan instance database (singleton pattern)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inisialisasi database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'diary.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            date TEXT
          )
          ''',
        );
      },
    );
  }

  // Fungsi untuk menambahkan catatan ke database
  Future<int> insertNote(Map<String, dynamic> note) async {
    final db = await database;
    return await db.insert('notes', note);
  }

  // Fungsi untuk mengambil semua catatan
  Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await database;
    return await db.query('notes');
  }

  // Fungsi untuk memperbarui catatan
  Future<int> updateNote(int id, Map<String, dynamic> note) async {
    final db = await database;
    return await db.update('notes', note, where: 'id = ?', whereArgs: [id]);
  }

  // Fungsi untuk menghapus catatan
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
