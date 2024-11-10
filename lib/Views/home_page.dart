import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import untuk format tanggal
import 'package:flutter_application_diary/db_helper.dart';
import 'package:flutter_application_diary/add_edit_note_page.dart';
import 'package:flutter_application_diary/preferences_helper.dart';

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
  List<Map<String, dynamic>> filteredNotes = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    await _fetchNotes();
    _updateFilteredNotes();
    await _loadThemeMode();
  }

  void _updateFilteredNotes() {
    setState(() {
      if (searchQuery.isEmpty) {
        filteredNotes = _notes;
      } else {
        filteredNotes = _notes.where((note) {
          final title = note['title'].toLowerCase();
          final content = note['content'].toLowerCase();
          return title.contains(searchQuery.toLowerCase()) || content.contains(searchQuery.toLowerCase());
        }).toList();
      }
    });
  }

  void _onSearchChanged(String query) {
    searchQuery = query;
    _updateFilteredNotes();
  }

  Future<void> _loadThemeMode() async {
    bool themeMode = await _preferencesHelper.getThemeMode();
    setState(() {
      _isDarkMode = themeMode;
    });
  }

  Future<void> _toggleTheme() async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    await _preferencesHelper.setThemeMode(_isDarkMode);
  }

  Future<void> _fetchNotes() async {
    final notes = await _dbHelper.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  void _addOrEditNote([Map<String, dynamic>? note]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditNotePage(
          noteId: note?['id'],
          initialTitle: note?['title'],
          initialContent: note?['content'],
          isDarkMode: _isDarkMode,
        ),
      ),
    );

    if (result != null) {
   if (result['id'] == null) {
      await _dbHelper.insertNote({
         'title': result['title'],
         'content': result['content'],
         'date': DateTime.now().toString(),
      });
   } else {
      await _dbHelper.updateNote(result['id'], result);
   }
   await _fetchNotes(); // Pastikan fetchNotes selesai
   setState(() {});     // Tambahkan setState untuk memaksa update tampilan
   _updateFilteredNotes();
}
  }

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
            // Hapus catatan dari database
            await _dbHelper.deleteNote(id);
            Navigator.of(context).pop();

            // Ambil ulang catatan dari database dan perbarui tampilan
            await _fetchNotes();
            _updateFilteredNotes();
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
              color: _isDarkMode ? Colors.white : Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: _isDarkMode ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Cari catatan...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: TextStyle(
                      color: _isDarkMode ? Colors.white54 : Colors.black54,
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
            Expanded(
              child: filteredNotes.isEmpty
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
                      itemCount: filteredNotes.length,
                      itemBuilder: (context, index) {
                        final note = filteredNotes[index];
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  note['content'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('yyyy-MM-dd').format(DateTime.parse(note['date'])),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => _deleteNoteConfirm(note['id']),
                            ),
                            onTap: () => _addOrEditNote(note),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: _isDarkMode ? Colors.purple[300] : Colors.purple[300],
          child: const Icon(Icons.add),
          onPressed: () => _addOrEditNote(),
        ),
      ),
    );
  }
}
