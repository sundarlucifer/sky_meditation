import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sky_meditation/models/models.dart';
import 'package:sky_meditation/utils/utils.dart';

class PlayerPage extends StatefulWidget {
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  Meditation meditation = meditationHolderUtil.meditation;

  AudioPlayer audioPlayer;
  AudioCache audioCache;

  int nextSectionInd = 0;
  bool isPlaying = false;

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    loadAndPlayNextSection();
    audioPlayer.completionHandler = () {
      final completedSection = meditation.sections[nextSectionInd-1];
      if (completedSection.duration!=null) {
        // var waitingFuture = Future.delayed(completedSection.duration, () {
        //   loadAndPlayNextSection();
        // });
      }
      loadAndPlayNextSection();
    };
    super.initState();
  }

  void loadAndPlayNextSection() {
    setState(() => isPlaying = false);
    if(nextSectionInd >= meditation.sections.length) {
      onSessionComplete();
      return;
    }
    audioCache.load(meditation.sections[nextSectionInd].assetUrl).then((value) {
      audioCache.play(meditation.sections[nextSectionInd].assetUrl);
      setState(() {
        nextSectionInd++;
        isPlaying = true;
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
        child: Material(
                  child: Center(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
                  child: Text('Meditation name', style: TextStyle(fontSize: 32)),
                ),
                Spacer(),
                Text(meditation.sections[nextSectionInd-1].name),
                Spacer(),
                ..._controlsHelper,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void playOrPause() {
    print('Pause/Play Section');
    if(isPlaying)
      audioPlayer.pause();
    else
      audioPlayer.resume();
    setState(() => isPlaying=!isPlaying);
  }
  void nextSection() {
    print('Next Section');
    loadAndPlayNextSection();
  }
  void prevSection() {
    print('Previous Section');
    if(nextSectionInd-1==0)
      return;
    setState(() => nextSectionInd-=2);
    loadAndPlayNextSection();
  }
  void replaySection() {
    print('Replay Section');
    setState(() => nextSectionInd-=1);
    loadAndPlayNextSection();
  }

  void onSessionComplete() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    audioCache.clearCache();
    super.dispose();
  }
}
