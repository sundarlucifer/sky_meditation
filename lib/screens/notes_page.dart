import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sky_meditation/screens/screens.dart';
import 'package:sky_meditation/services/services.dart';
import 'package:sky_meditation/utils/utils.dart';

class NotesPage extends StatefulWidget {
  static const TAG = 'notes-page';

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(title: Text('Meditation Notes')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => NewNotePage())),
      ),
      body: StreamBuilder(
        stream: authService.getMeditationNotesAsStream(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (!snapshot.hasData || snapshot.data.documents.length == 0)
                return Center(child: Text('No note has been written yet'));
              return ListView(
                children: snapshot.data.documents
                    .map<Widget>((doc) => _buildCard(doc.data))
                    .toList(),
              );
          }
        },
      ),
    );
  }

  _buildCard(Map note) {
    return ListTile(
      title: Text(note['title']),
      subtitle: Text(((note['content'] as String)+' '*50).substring(0, 50).trim()+ '...'),
      trailing: Text((note['written_on'] as Timestamp)
          .toDate()
          .toString()
          .substring(0, 10)),
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => NewNotePage(note: note))),
      contentPadding: EdgeInsets.all(10),
    );
  }
}
