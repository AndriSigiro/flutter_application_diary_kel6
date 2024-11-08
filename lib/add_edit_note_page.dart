import 'package:flutter/material.dart';

class AddEditNotePage extends StatefulWidget {
  final int? noteId;
  final String? initialTitle;
  final String? initialContent;

  const AddEditNotePage({
    Key? key,
    this.noteId,
    this.initialTitle,
    this.initialContent,
  }) : super(key: key);

  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.noteId != null) {
      _titleController.text = widget.initialTitle ?? '';
      _contentController.text = widget.initialContent ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text;
    final content = _contentController.text;
    
    if (title.isNotEmpty && content.isNotEmpty) {
      Navigator.of(context).pop({
        'id': widget.noteId,
        'title': title,
        'content': content,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteId == null ? 'Add Note' : 'Edit Note'),
        actions: [
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
  padding: const EdgeInsets.all(16.0),
  child: ElevatedButton(
    onPressed: _saveNote,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue, // Mengatur warna latar belakang tombol menjadi biru
      padding: const EdgeInsets.symmetric(vertical: 16.0),
    ),
    child: const Text(
      'Simpan',
      style: TextStyle(fontSize: 16, color: Colors.white), // Warna teks putih agar kontras dengan tombol biru
    ),
  ),
),

    );
  }
}
