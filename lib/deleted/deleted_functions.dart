// Les fionctions utilisées au cours du developpement
// mais par la suite supprimée ou changées
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:ynovify/models/manager_player.dart';

ManagerPlayer managerPlayer = ManagerPlayer();

Widget _currentDuration() {
  return Text(displayDuration(managerPlayer.getCurrentDuration()),
      style: const TextStyle(fontSize: 15));
}

Widget _sliderDuration() {
  return LinearPercentIndicator(
    lineHeight: 10.0,
    percent: getPercent(),
    backgroundColor: Colors.grey,
    progressColor: Colors.blue,
  );
}

double getPercent() {
  return managerPlayer.getCurrentDuration().inSeconds *
      100 /
      managerPlayer.duration.inSeconds /
      100;
}

Widget _theDurations() {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
    Container(
      margin: const EdgeInsets.only(left: 15.0),
      child: StreamBuilder<Duration>(
        stream: managerPlayer.player.player.positionStream,
        builder: (context, snapshot) {
          return _currentDuration();
        },
      ),
    ),
    const Spacer(),
    Container(
      margin: const EdgeInsets.only(right: 15.0),
      child: Text(displayDuration(managerPlayer.duration),
          style: const TextStyle(fontSize: 15)),
    ),
  ]);
}

String displayDuration(Duration duration) {
  int hours = 0;
  String hour = "";
  int minutes = 0;
  String minute = "";
  int seconds = 0;
  String second = "";

  hours = duration.inHours;
  if (hours != 0) {
    hour = (hours < 10) ? "0$hours:" : "$hours:";
  }

  minutes = duration.inMinutes % 60;
  minute = (minutes < 10) ? "0$minutes:" : "$minutes:";

  seconds = duration.inSeconds % 60;
  second = (seconds < 10) ? "0$seconds" : "$seconds";

  return "$hour$minute$second";
}
