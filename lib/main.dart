import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/material.dart';
import 'package:ynovify/models/manager_player.dart';
import 'package:ynovify/models/player.dart';
import 'dart:async';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YNOVIFY',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const MyHomePage(title: 'Please don\'t stop the music !'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ManagerPlayer managerPlayer;

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    managerPlayer = ManagerPlayer();
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      managerPlayer.duration = managerPlayer.player.player.duration!;
    });
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            //Container Image
            Container(
              margin: const EdgeInsets.only(top: 50.0),
              child: Image.asset(
                managerPlayer.selectedMusic.imagePath,
                width: 300,
                height: 300,
                fit: BoxFit.fill,
              ),
            ),
            // Container Artiste
            Container(
              margin: const EdgeInsets.only(top: 25.0),
              child: Text(managerPlayer.selectedMusic.singer,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold)),
            ),
            // Container Musique
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(managerPlayer.selectedMusic.title,
                  style: const TextStyle(fontSize: 20)),
            ),
            const Spacer(),
            // Container Slider
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: StreamBuilder<Duration>(
                stream: managerPlayer.player.player.positionStream,
                builder: (context, snapshot) {
                  return _sliderDuration();
                },
              ),
            ),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    icon: const Icon(
                      Icons.skip_previous,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        managerPlayer.prevMusic();
                      });
                    }),
                IconButton(
                    icon: const Icon(
                      Icons.keyboard_double_arrow_left,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        managerPlayer.back(10);
                        managerPlayer.play();
                      });
                    }),
                IconButton(
                  icon: Icon(
                    getIconState(managerPlayer.player.state),
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      switch (managerPlayer.player.state) {
                        case MyPlayerState.paused:
                          managerPlayer.player.state = MyPlayerState.playing;
                          managerPlayer.play();
                          break;
                        case MyPlayerState.playing:
                          managerPlayer.player.state = MyPlayerState.paused;
                          managerPlayer.pause();
                          break;
                      }
                    });
                  },
                ),
                IconButton(
                    icon: const Icon(
                      Icons.keyboard_double_arrow_right,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        managerPlayer.skip(10);
                      });
                    }),
                IconButton(
                    icon: const Icon(
                      Icons.skip_next,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        managerPlayer.nextMusic();
                      });
                    }),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _sliderDuration() {
    return ProgressBar(
      progress: managerPlayer.getCurrentDuration(),
      total: managerPlayer.duration,
      baseBarColor: Colors.black,
      onSeek: managerPlayer.seek,
    );
  }

  IconData getIconState(MyPlayerState state) {
    switch (state) {
      case MyPlayerState.paused:
        {
          return Icons.play_arrow;
        }
      case MyPlayerState.playing:
        {
          return Icons.pause;
        }
    }
  }
}
