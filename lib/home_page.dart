import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import untuk format tanggal
import 'db_helper.dart';
import 'add_edit_note_page.dart';
import 'preferences_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DBHelper _dbHelper = DBHelper();
  final PreferencesHelper _preferencesHelper = PreferencesHelper();
  bool _isDarkMode = false;
  List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _fetchNotes();
    _loadThemeMode();
  }

  /// Memuat preferensi tema dari `SharedPreferences`
  Future<void> _loadThemeMode() async {
    bool themeMode = await _preferencesHelper.getThemeMode();
    setState(() {
      _isDarkMode = themeMode;
    });
  }

  /// Mengganti tema dan menyimpannya ke `SharedPreferences`
  Future<void> _toggleTheme() async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    await _preferencesHelper.setThemeMode(_isDarkMode);
  }

  /// Mengambil catatan dari database
  Future<void> _fetchNotes() async {
    final notes = await _dbHelper.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  /// Menambah atau mengedit catatan
  void _addOrEditNote([Map<String, dynamic>? note]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditNotePage(
          noteId: note?['id'],
          initialTitle: note?['title'],
          initialContent: note?['content'],
          isDarkMode: _isDarkMode, // Mengirim status tema ke halaman edit
        ),
      ),
    );

    if (result != null) {
      if (result['id'] == null) {
        // Tambah catatan baru dengan tanggal otomatis
        await _dbHelper.insertNote({
          'title': result['title'],
          'content': result['content'],
          'date': DateTime.now().toString(), // Tanggal dan waktu otomatis
        });
      } else {
        // Perbarui catatan yang sudah ada tanpa mengubah tanggal
        await _dbHelper.updateNote(result['id'], result);
      }
      _fetchNotes();
    }
  }

  /// Konfirmasi sebelum menghapus catatan
  Future<void> _deleteNoteConfirm(int id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Catatan'),
        content: const Text('Apakah Anda yakin ingin menghapus catatan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await _dbHelper.deleteNote(id);
              Navigator.of(context).pop();
              _fetchNotes();
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: _isDarkMode ? Colors.black : Colors.purple[100],
          title: Text(
            'My Diary',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: _isDarkMode ? Colors.white : Colors.black87,
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isDarkMode ? Icons.brightness_7 : Icons.brightness_4,
                color: Colors.grey[700],
              ),
              onPressed: _toggleTheme,
            ),
          ],
        ),
        body: _notes.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.note_alt, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 10),
                    Text(
                      'Belum ada catatan.',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(Icons.note, color: Colors.purple[300]),
                      title: Text(
                        note['title'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.purple[800],
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note['content'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            // Jika note['date'] tidak null, format tanggal; jika null, tampilkan teks kosong
                            note['date'] != null
                                ? DateFormat('yyyy-MM-dd – kk:mm')
                                    .format(DateTime.parse(note['date']))
                                : '', // Format tanggal
                            style: TextStyle(color: Colors.grey[500], fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red[400]),
                        onPressed: () => _deleteNoteConfirm(note['id']),
                      ),
                      onTap: () => _addOrEditNote(note),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addOrEditNote(),
          backgroundColor: Colors.purple[300],
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
