import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sky_meditation/screens/screens.dart';
import 'package:sky_meditation/utils/utils.dart';
import '../models/models.dart';

class TweakPage extends StatefulWidget {
  const TweakPage({Key key}) : super(key: key);

  @override
  _TweakPageState createState() => _TweakPageState();
}

class _TweakPageState extends State<TweakPage> {
  Meditation meditation = meditationHolderUtil.meditation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thuriyatheetham Meditation'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Meditation Sections',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                'Duration',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ...sectionListWidgets(),
            Center(
              child: ElevatedButton(
                child: Text('Start Meditation'),
                onPressed: () {
                  meditationHolderUtil.meditation = meditation;
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => PlayerPage()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  sectionListWidgets() {
    var sections = [];
    for (int ind = 0; ind < meditation.sections.length; ind++) {
      final e = meditation.sections[ind];
      sections.add(
        ListCard(
            title: e.name,
            duration: e.duration,
            onRemove: () {
              meditation.sections.removeAt(ind);
              setState(() => meditationHolderUtil.meditation = meditation);
            },
            onDurationChanged: (Duration d) {
              meditation.sections[ind].duration = d;
              setState(() => meditationHolderUtil.meditation = meditation);
            }),
      );
    }
    return sections;
  }
}

class ListCard extends StatefulWidget {
  final String title;
  final Duration duration;
  final Function onRemove;
  final Function onDurationChanged;

  ListCard({
    Key key,
    @required this.title,
    @required this.duration,
    @required this.onRemove,
    @required this.onDurationChanged,
  }) : super(key: key);

  @override
  _ListCardState createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _minsTextController;
  TextEditingController _secsTextController;

  void initValues() {
    if (widget.duration != null) {
      _minsTextController =
          TextEditingController(text: widget.duration.inMinutes.toString());
      final secs = widget.duration.inSeconds.remainder(60);
      _secsTextController = TextEditingController(text: secs.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      trailing: Text(widget.duration != null
          ? '${widget.duration.inMinutes}:${widget.duration.inSeconds.remainder(60)} mins'
          : ''),
      onTap: () {
        initValues();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(widget.title),
                content: widget.duration != null
                    ? Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: TextFormField(
                                    controller: _minsTextController,
                                    maxLength: 3,
                                    keyboardType: TextInputType.number,
                                    validator: (val) {
                                      if (val.isEmpty) return 'Enter value';
                                      return int.parse(val) >= 0
                                          ? null
                                          : 'Must not be negative';
                                    },
                                  ),
                                ),
                                Text('mins'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: TextFormField(
                                      controller: _secsTextController,
                                      maxLength: 2,
                                      keyboardType: TextInputType.number,
                                      validator: (val) {
                                        if (val.isEmpty) return 'Enter value';
                                        int secs = int.parse(val);
                                        if (secs < 0)
                                          return 'Must be greater than 0';
                                        if (secs > 59)
                                          return 'Must be less than 60';
                                        return null;
                                      }),
                                ),
                                Text('secs'),
                              ],
                            ),
                          ],
                        ),
                      )
                    : null,
                actions: [
                  if (widget.duration != null)
                    TextButton(
                      onPressed: () {
                        if (!_formKey.currentState.validate()) return;
                        int mins = int.parse(_minsTextController.text);
                        int secs = int.parse(_secsTextController.text);
                        widget.onDurationChanged(
                            Duration(minutes: mins, seconds: secs));
                        Navigator.pop(context);
                      },
                      child: Text('Update'),
                    ),
                  TextButton(
                    onPressed: () {
                      widget.onRemove();
                      Navigator.pop(context);
                    },
                    child: Text('Remove'),
                  ),
                ],
              );
            });
      },
    );
  }
}
