import 'package:flutter/material.dart';
import '../components/note_item.dart';
import '../components/note_input_dialog.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  // Sample initial notes data
  List<Map<String, dynamic>> notes = [
    {
      'id': '1',
      'content': 'Learn Flutter',
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'id': '2',
      'content': 'Complete the tutorial',
      'createdAt': DateTime.now().toIso8601String(),
    },
  ];

  // Controllers and state variables
  TextEditingController noteController = TextEditingController();
  Map<String, dynamic>? editingNote;

  // Function to save a new or updated note
  void saveNote() {
    if (noteController.text.trim().isEmpty) return;

    setState(() {
      if (editingNote != null) {
        // Update existing note
        for (int i = 0; i < notes.length; i++) {
          if (notes[i]['id'] == editingNote!['id']) {
            notes[i] = {
              ...notes[i],
              'content': noteController.text,
              'updatedAt': DateTime.now().toIso8601String(),
            };
            break;
          }
        }
        editingNote = null;
      } else {
        // Add new note
        final newNote = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': noteController.text,
          'createdAt': DateTime.now().toIso8601String(),
        };
        notes.insert(0, newNote);
      }
    });

    noteController.clear();
  }

  // Function to delete a note
  void deleteNote(String id) {
    setState(() {
      notes.removeWhere((note) => note['id'] == id);
    });
  }

  // Function to open edit mode
  void editNote(Map<String, dynamic> note) {
    editingNote = note;
    noteController.text = note['content'];
    showNoteDialog();
  }

  // Show dialog for adding/editing notes
  void showNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => NoteInputDialog(
        controller: noteController,
        isEditing: editingNote != null,
        onSave: saveNote,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header with title and add button
          Container(
            height: 100,
            color: Colors.blue,
            padding: EdgeInsets.only(
              bottom: 15,
              left: 20,
              right: 20,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Notes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    editingNote = null;
                    noteController.clear();
                    showNoteDialog();
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Text(
                        '+',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Notes list or empty state
          Expanded(
            child: notes.isNotEmpty
                ? ListView.builder(
                    padding: EdgeInsets.all(15),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return NoteItem(
                        note: notes[index],
                        onEdit: editNote,
                        onDelete: deleteNote,
                      );
                    },
                  )
                : Center(
                    child: Text(
                      'No notes yet. Create one!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF7F8C8D),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    noteController.dispose();
    super.dispose();
  }
}