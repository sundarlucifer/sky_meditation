import 'package:sky_meditation/models/models.dart';

class MeditationHolder {
  Meditation meditation;
  bool isWaitTimePaused = false;
  Map meditaionStatistics;
}

final meditationHolderUtil = MeditationHolder();