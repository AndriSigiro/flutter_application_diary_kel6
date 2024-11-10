import 'package:flutter/material.dart';

class AddEditNotePage extends StatefulWidget {
  final int? noteId;
  final String? initialTitle;
  final String? initialContent;
  final bool isDarkMode; 

  const AddEditNotePage({
    Key? key,
    this.noteId,
    this.initialTitle,
    this.initialContent,
    required this.isDarkMode,
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
    return MaterialApp(
      theme: widget.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: widget.isDarkMode ? Colors.black : Colors.purple[100],
          title: Text(
            widget.noteId == null ? 'Tambah Catatan' : 'Edit Catatan',
            style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black87),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            ),
          iconTheme: IconThemeData(color: widget.isDarkMode ? Colors.white : Colors.black87),
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Judul',
                  labelStyle: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.purple[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black87),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Isi Catatan',
                  labelStyle: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.purple[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black87),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _saveNote,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.isDarkMode ? Colors.grey[800] : Colors.purple[300],
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Simpan',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
