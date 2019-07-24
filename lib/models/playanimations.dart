import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class PlayAnimations with ChangeNotifier {
  static Map<String, List<AnimationController>> iconMap = new Map();
  static int prevIndex;
  static String prevStr;
  static bool isPlaying;
  static String songNm;

  set setPlay(bool play) {
    isPlaying = play;
    notifyListeners();
  }

  get playState => isPlaying;
  get songName => songNm;
  set setSong(String song) {
    songNm = song;
    notifyListeners();
  }

  disposeIt() {
    iconMap.forEach((key, controllerList) {
      for (var cont in controllerList) {
        cont.dispose();
      }
    });
  }
}
