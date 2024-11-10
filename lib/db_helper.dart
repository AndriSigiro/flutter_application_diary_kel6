import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

<<<<<<< HEAD
  // Mendapatkan instance database
=======
  // Mendapatkan instance database (singleton pattern)
>>>>>>> 8c5cfbe3e93793038bd2935279d648be176bfdc6
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

<<<<<<< HEAD
  // Menambahkan catatan ke database
=======
  // Fungsi untuk menambahkan catatan ke database
>>>>>>> 8c5cfbe3e93793038bd2935279d648be176bfdc6
  Future<int> insertNote(Map<String, dynamic> note) async {
    final db = await database;
    return await db.insert('notes', note);
  }

<<<<<<< HEAD
  // Mengambil semua catatan
=======
  // Fungsi untuk mengambil semua catatan
>>>>>>> 8c5cfbe3e93793038bd2935279d648be176bfdc6
  Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await database;
    return await db.query('notes');
  }

<<<<<<< HEAD
  // Memperbarui catatan
=======
  // Fungsi untuk memperbarui catatan
>>>>>>> 8c5cfbe3e93793038bd2935279d648be176bfdc6
  Future<int> updateNote(int id, Map<String, dynamic> note) async {
    final db = await database;
    return await db.update('notes', note, where: 'id = ?', whereArgs: [id]);
  }

<<<<<<< HEAD
  // Menghapus catatan
=======
  // Fungsi untuk menghapus catatan
>>>>>>> 8c5cfbe3e93793038bd2935279d648be176bfdc6
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
