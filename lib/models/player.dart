import 'package:just_audio/just_audio.dart';

class Player {
  final player = AudioPlayer();
  MyPlayerState state = MyPlayerState.paused;
}

enum MyPlayerState { paused, playing }
