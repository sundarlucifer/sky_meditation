import 'dart:async';
import 'dart:collection';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sky_meditation/models/models.dart';
import 'package:sky_meditation/screens/screens.dart';
import 'package:sky_meditation/utils/utils.dart';

class PlayerPage extends StatefulWidget {
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  Meditation meditation;

  AudioPlayer audioPlayer;
  AudioCache audioCache;

  int nextSectionInd = 0;
  bool isPlaying = false;
  bool isWaitTime = false;

  WaitTimerWidget waitTimer;

  DateTime startTime, endTime;
  Timer playTimer;
  Duration playTime = Duration();
  Duration awayTime = Duration();
  int interactionCounter = 0;
  int replayCounter = 0;
  int pauseCounter = 0;

  bool _isLoading = true;

  @override
  void initState() {
    meditation = meditationHolderUtil.meditation;
    meditationHolderUtil.meditaionStatistics = null;
    
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    loadAndPlayNextSection();
    audioPlayer.completionHandler = _playerCompletionHandler();

    startTime = DateTime.now();
    _initTimers();
    super.initState();
  }

  _initTimers() {
    playTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (isPlaying || isWaitTime)
        playTime += Duration(seconds: 1);
      else
        awayTime += Duration(seconds: 1);
    });
  }

  _playerCompletionHandler() {
    return () {
      final completedSection = meditation.sections[nextSectionInd - 1];
      if (completedSection.duration != null) {
        setState(() {
          isWaitTime = true;
          waitTimer = _newWaitTimer(completedSection.duration);
          print('wait timer set $waitTimer');
        });
        return;
      }
      loadAndPlayNextSection();
    };
  }

  _newWaitTimer(duration) {
    return WaitTimerWidget(
      duration: duration,
      onDurationComplete: () {
        setState(() {
          waitTimer = null;
          isWaitTime = false;
        });
        loadAndPlayNextSection();
      },
    );
  }

  void loadAndPlayNextSection() {
    setState(() {
      isPlaying = false;
      waitTimer = null;
      isWaitTime = false;
      meditationHolderUtil.isWaitTimePaused = false;
    });
    audioCache.load(meditation.sections[nextSectionInd].assetUrl).then((value) {
      audioCache.play(meditation.sections[nextSectionInd].assetUrl);
      setState(() {
        nextSectionInd++;
        isPlaying = true;
        _isLoading = false;
      });
    });
  }

  final List<Widget> _controlsHelper = [
    'Tap to pause or play',
    'Double tap to replay the current section',
    'Swipe left for previos section',
    'Swipe right for next section',
  ].map((e) => Text(e, style: TextStyle(fontWeight: FontWeight.w200))).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      body: GestureDetector(
        onTap: () => playOrPause(),
        onDoubleTap: () => replaySection(),
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity > 0) {
            prevSection();
          } else if (details.primaryVelocity < 0) {
            nextSection();
          }
        },
        child: _isLoading
            ? LoadingPage()
            : Material(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 20.0),
                        child: Text(meditation.title,
                            style: TextStyle(fontSize: 32)),
                      ),
                      Spacer(),
                      Text(
                        (isPlaying ? 'Playing: ' : 'Paused: ') +
                            meditation.sections[nextSectionInd - 1].name,
                        style: TextStyle(fontSize: 24),
                      ),
                      waitTimer ?? Container(),
                      SizedBox(height: 12),
                      if (nextSectionInd < meditation.sections.length)
                        Text('Next in queue: ' +
                            meditation.sections[nextSectionInd].name),
                      Spacer(),
                      ..._controlsHelper,
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void playOrPause() {
    interactionCounter++;
    showSnakbar((isPlaying ? 'Paused' : 'Resuming') + ' Section');
    if (isPlaying) {
      pauseCounter++;
      audioPlayer.pause();
      meditationHolderUtil.isWaitTimePaused = true;
    } else {
      if (!isWaitTime) audioPlayer.resume();
      meditationHolderUtil.isWaitTimePaused = false;
    }
    setState(() => isPlaying = !isPlaying);
  }

  void nextSection() {
    interactionCounter++;
    if (nextSectionInd >= meditation.sections.length) {
      onSessionComplete();
      return;
    }
    showSnakbar('Playing Next Section');
    loadAndPlayNextSection();
  }

  void prevSection() {
    interactionCounter++;
    replayCounter++;
    if (nextSectionInd - 1 == 0) return;
    showSnakbar('Playing Previous Section');
    setState(() => nextSectionInd -= 2);
    loadAndPlayNextSection();
  }

  void replaySection() {
    interactionCounter++;
    replayCounter++;
    showSnakbar('Replaying Section');
    setState(() => nextSectionInd -= 1);
    audioPlayer.stop();
    loadAndPlayNextSection();
  }

  void onSessionComplete() {
    endTime = DateTime.now();
    final resultMap = HashMap<String, dynamic>();
    resultMap['meditation'] = meditation.title;
    resultMap['start_time'] = startTime;
    resultMap['end_time'] = endTime;
    resultMap['play_time'] = playTime;
    resultMap['away_time'] = awayTime;
    resultMap['interaction_count'] = interactionCounter;
    resultMap['pause_count'] = pauseCounter;
    resultMap['replay_count'] = replayCounter;
    meditationHolderUtil.meditaionStatistics = resultMap;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => SessionResultPage()));
  }

  void showSnakbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 500),
    ));
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    audioCache.clearCache();
    playTimer.cancel();
    super.dispose();
  }
}

class WaitTimerWidget extends StatefulWidget {
  final Duration duration;
  final Function onDurationComplete;

  const WaitTimerWidget(
      {Key key, @required this.duration, @required this.onDurationComplete})
      : super(key: key);
  @override
  _WaitTimerWidgetState createState() => _WaitTimerWidgetState();
}

class _WaitTimerWidgetState extends State<WaitTimerWidget> {
  Duration runningTime = Duration();
  Timer timer;

  @override
  void initState() {
    super.initState();
    runningTime = widget.duration;
    timer = Timer.periodic(Duration(seconds: 1), (_timer) {
      setState(() {
        if (meditationHolderUtil.isWaitTimePaused) {
          return;
        }
        runningTime -= Duration(seconds: 1);
        if (runningTime <= Duration(seconds: 0)) {
          widget.onDurationComplete();
          this.dispose();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          Text('Section Timer', style: TextStyle(fontSize: 20)),
          Text(
            '${runningTime.inMinutes} : ${runningTime.inSeconds.remainder(60)} mins',
            style: TextStyle(fontSize: 32),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
