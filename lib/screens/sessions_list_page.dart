import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sky_meditation/screens/screens.dart';
import 'package:sky_meditation/services/services.dart';
import 'package:sky_meditation/utils/utils.dart';

class SessionsListPage extends StatefulWidget {
  static const TAG = 'sessions-list-page';

  @override
  _SessionsListPageState createState() => _SessionsListPageState();
}

class _SessionsListPageState extends State<SessionsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(title: Text('Meditation History')),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: authService.getMeditationSessionsAsStream(),
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (!snapshot.hasData || snapshot.data.documents.length == 0)
                  return Center(
                      child:
                          Text('No Meditations has been saved to cloud yet'));
                return Column(
                    children: snapshot.data.documents
                        .map<Widget>((doc) => _buildListTile(doc.data))
                        .toList());
            }
          },
        ),
      ),
    );
  }

  _buildListTile(Map<String, dynamic> dataMap) {
    final duration = _strToDuration(dataMap['play_time']) +
        _strToDuration(dataMap['away_time']);
    return ListTile(
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text((dataMap['start_time'] as Timestamp)
              .toDate()
              .toString()
              .substring(0, 10)),
          Text((dataMap['start_time'] as Timestamp)
              .toDate()
              .toString()
              .substring(11, 19)),
        ],
      ),
      title: Text(
        dataMap['meditation'],
        style: TextStyle(fontSize: 20),
      ),
      subtitle: Text(
          'Duration: ${duration.inMinutes}m:${duration.inSeconds.remainder(60)}s'),
      onTap: () {
        final formattedMap = _formatMap(dataMap);
        meditationHolderUtil.meditaionStatistics = formattedMap;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => SessionResultPage(viewOnly: true)));
      },
      contentPadding: EdgeInsets.all(10),
    );
  }

  _strToDuration(String str) {
    final parts = str.split(':');
    print(parts);
    final mins = int.parse(parts[1]);
    final secs = int.parse(parts[2].split('.')[0]);
    return Duration(minutes: mins, seconds: secs);
  }

  _formatMap(Map<String, dynamic> dataMap) {
    final res = HashMap<String, dynamic>();
    res.addAll(dataMap);
    res['start_time'] = (res['start_time'] as Timestamp).toDate();
    res['end_time'] = (res['end_time'] as Timestamp).toDate();
    res['play_time'] = _strToDuration(res['play_time']);
    res['away_time'] = _strToDuration(res['away_time']);
    return res;
  }
}
