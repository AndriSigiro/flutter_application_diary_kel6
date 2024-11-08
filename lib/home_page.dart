import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'add_edit_note_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DBHelper();
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    notes = await dbHelper.getNotes();
    setState(() {});
  }

  Future<void> _addOrEditNote({int? id}) async {
    final existingNote = id != null
        ? notes.firstWhere((note) => note['id'] == id, orElse: () => {})
        : {};

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditNotePage(
          noteId: id,
          initialTitle: existingNote['title'],
          initialContent: existingNote['content'],
        ),
      ),
    );

    if (result != null) {
      final title = result['title'] as String;
      final content = result['content'] as String;
      
      if (id == null) {
        // Tambah catatan baru
        await dbHelper.insertNote({
          'title': title,
          'content': content,
          'date': DateTime.now().toIso8601String(),
        });
      } else {
        // Update catatan yang ada
        await dbHelper.updateNote(id, {
          'title': title,
          'content': content,
          'date': DateTime.now().toIso8601String(),
        });
      }

      // Muat ulang catatan setelah perubahan
      _loadNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Diary')),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            title: Text(note['title']),
            subtitle: Text(note['content']),
            onTap: () => _addOrEditNote(id: note['id']),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await dbHelper.deleteNote(note['id']);
                _loadNotes();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addOrEditNote(),
      ),
    );
  }
}
