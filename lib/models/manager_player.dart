import 'player.dart';
import 'music.dart';
import '../utils/music_list_bdd.dart';

class ManagerPlayer {
  Player player = Player();
  List<Music> musicList = musicListBDD;
  int selectedMusicIndex = 0;
  Duration duration = Duration.zero;
  Duration currentDuration = Duration.zero;

  late Music selectedMusic;
  late int numberOfMusic;

  Music getSelectedMusic() {
    return selectedMusic;
  }

  Duration getCurrentDuration() {
    player.player.positionStream.listen((position) {
      currentDuration = position;
    });
    return currentDuration;
  }

  ManagerPlayer() {
    selectedMusic = musicList[selectedMusicIndex];
    numberOfMusic = musicList.length;
    setMusic();
  }

  prevMusic() {
    if (selectedMusicIndex == 0) {
      selectedMusicIndex = numberOfMusic - 1;
    } else {
      selectedMusicIndex -= 1;
    }

    selectedMusic = musicList[selectedMusicIndex];
    setMusic();
  }

  nextMusic() {
    if (selectedMusicIndex == numberOfMusic - 1) {
      selectedMusicIndex = 0;
    } else {
      selectedMusicIndex += 1;
    }

    selectedMusic = musicList[selectedMusicIndex];
    setMusic();
  }

  skip(int seconds) {
    Duration time = getCurrentDuration();
    if (time.inSeconds + 5 > duration.inSeconds) {
      nextMusic();
    } else if (time.inSeconds + seconds > duration.inSeconds) {
      player.player.seek(Duration(seconds: duration.inSeconds));
    } else {
      int newTime = time.inSeconds + seconds;
      player.player.seek(Duration(seconds: newTime));
    }
  }

  back(int seconds) {
    Duration time = getCurrentDuration();

    if (time.inSeconds < 3) {
      prevMusic();
    } else if (time.inSeconds < seconds) {
      player.player.seek(Duration.zero);
    } else {
      int newTime = time.inSeconds - seconds;
      player.player.seek(Duration(seconds: newTime));
    }
  }

  void seek(Duration time) {
    player.player.seek(time);
  }

  pause() {
    player.player.pause();
  }

  play() {
    player.player.play();
  }

  setMusic() async {
    duration = (await player.player.setAsset(selectedMusic.urlSong))!;
  }
}
