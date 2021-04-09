import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sky_meditation/services/services.dart';

class NewNotePage extends StatefulWidget {
  final Map note;

  const NewNotePage({Key key, this.note}) : super(key: key);
  @override
  _NewNotePageState createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  bool _viewOnly = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      setState(() => _viewOnly = true);
      _titleController.text = widget.note['title'];
      _contentController.text = widget.note['content'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Write a new Note')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _header('Title'),
                      TextFormField(
                        controller: _titleController,
                        readOnly: _viewOnly,
                        decoration: InputDecoration(border: OutlineInputBorder()),
                        validator: (value) =>
                            value.trim().isEmpty ? "Can't be empty" : null,
                      ),
                      SizedBox(height: 12),
                      _header('Content'),
                      TextFormField(
                        controller: _contentController,
                        readOnly: _viewOnly,
                        decoration: InputDecoration(border: OutlineInputBorder()),
                        minLines: 10,
                        maxLines: 100,
                        validator: (value) =>
                            value.trim().isEmpty ? "Can't be empty" : null,
                      ),
                      SizedBox(height: 12),
                      if (!_viewOnly)
                        ElevatedButton(
                          child: Text('Save'),
                          onPressed: _saveNoteToCloud,
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  _header(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Text(title, style: TextStyle(fontSize: 32)),
    );
  }

  _saveNoteToCloud() {
    if (!_formKey.currentState.validate()) return;

    setState(() => _isLoading = true);

    Map noteMap = HashMap<String, dynamic>();
    noteMap['title'] = _titleController.text;
    noteMap['content'] = _contentController.text;
    authService.postMeditationNote(noteMap).then((_) {
      setState(() => _isLoading = false);
      _showSnackbar('Note saved to cloud successfully!');
      Navigator.pop(context);
    }).onError((e, _) {
      setState(() => _isLoading = false);
      _showSnackbar("Couldn't connect to cloud. Note not saved!");
    });
  }

  _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
