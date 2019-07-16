import 'package:flutter/animation.dart';

class PlayAnimations {
  static Map<String, List<AnimationController>> iconMap = new Map();
  static int prevIndex;
  static String prevStr;
  static bool isPlaying;
  static String songNm;

  dispose() {
    iconMap.forEach((key, controllerList) {
      for (var cont in controllerList) {
        cont.dispose();
      }
    });
  }
}
