import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:sky_meditation/screens/screens.dart';
import 'package:sky_meditation/services/services.dart';
import 'package:sky_meditation/utils/utils.dart';

const _resultTextStyle = TextStyle(fontSize: 20);

class SessionResultPage extends StatefulWidget {
  final bool viewOnly;

  const SessionResultPage({Key key, this.viewOnly = false}) : super(key: key);
  @override
  _SessionResultPageState createState() => _SessionResultPageState();
}

class _SessionResultPageState extends State<SessionResultPage> {
  final Map resultMap = HashMap<String, dynamic>();

  double _width = 300;

  bool _isUploadingToCloud = true;
  bool _isUploadedToCloud = false;

  @override
  initState() {
    super.initState();
    resultMap.addAll(meditationHolderUtil.meditaionStatistics);
    if (!widget.viewOnly) _uploadDetailsToCloud();
  }

  _uploadDetailsToCloud() {
    authService.postMeditationSession(resultMap).then((_) {
      setState(() {
        _isUploadedToCloud = true;
        _isUploadingToCloud = false;
      });
      _showSnackbar('Session details uploaded to cloud!');
    }).onError((e, _) {
      print(e);
      setState(() {
        _isUploadedToCloud = false;
        _isUploadingToCloud = false;
      });
      _showSnackbar("Couldn't connect to cloud. Session not saved.");
    });
  }

  _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Session Statistics'),
        actions: [
          if (!widget.viewOnly)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _getCloudAction(),
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _resultListTile('Mediation', resultMap['meditation']),
            _resultListTile('Start time', resultMap['start_time']),
            _resultListTile('End time', resultMap['end_time']),
            _resultListTile('Total session duration',
                resultMap['play_time'] + resultMap['away_time']),
            _resultListTile(
                'Total meditation duration', resultMap['play_time']),
            _resultListTile('Total away duration', resultMap['away_time']),
            _resultListTile(
                'Total interaction made', resultMap['interaction_count']),
            _resultListTile('Number of pauses', resultMap['pause_count']),
            _resultListTile(
                "Number of 'replay'/'prev section'", resultMap['replay_count']),
            if (!widget.viewOnly)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextButton(
                  child: Text(
                      'Tap here to write a note on your meditation experience!'),
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => NewNotePage())),
                ),
              )
          ],
        ),
      ),
    );
  }

  _resultListTile(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: (_width - 16) * 0.58,
              child: Text(title, style: _resultTextStyle)),
          Text(':', style: _resultTextStyle),
          SizedBox(width: (_width - 16) * 0.38, child: _buildValueText(value)),
        ],
      ),
    );
  }

  _getCloudAction() {
    if (_isUploadingToCloud)
      return Icon(Icons.cloud_upload_outlined, color: Colors.white);
    else if (_isUploadedToCloud)
      return Icon(Icons.cloud_done_outlined, color: Colors.white);
    else
      return TextButton(
        child: Text('Save to cloud', style: TextStyle(color: Colors.white)),
        onPressed: _uploadDetailsToCloud,
      );
  }

  _buildValueText(value) {
    if (value is Duration)
      return _durationText(value);
    else if (value is int)
      return _countText(value);
    else if (value is DateTime)
      return Text(value.toString().substring(11, 19), style: _resultTextStyle);
    else
      return Text(value.toString(), style: _resultTextStyle);
  }

  _countText(int count) {
    return Text(count.toString(), style: _resultTextStyle);
  }

  _durationText(Duration duration) {
    return Text(
      '${duration.inMinutes}m:${duration.inSeconds.remainder(60)}s',
      style: _resultTextStyle,
    );
  }
}
