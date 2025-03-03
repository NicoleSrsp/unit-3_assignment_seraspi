import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

void handleAppLifecycle(AppLifecycleState state, AudioPlayer audioPlayer, bool isPlaying) {
  if (state == AppLifecycleState.paused) {
    audioPlayer.pause();
  } else if (state == AppLifecycleState.resumed && isPlaying) {
    audioPlayer.resume();
  }
}
