import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Playerr extends ChangeNotifier {
  //StreamController cont;
  CollectionReference allSongs = Firestore.instance.collection('/allSongs');
  Stream str;
  static FlutterSound player = FlutterSound();
  // Future<FlutterSound> player1() async {
  //   if (player == null) {
  //     SharedPreferences sp = await SharedPreferences.getInstance();
  //     if (sp.getString('player1') == null) {
  //       Playerr.player = FlutterSound(false);
  //     } else {
  //       Playerr.player = FlutterSound(true);
  //     }
  //   }
  //   return player;
  // }

  getAllSongs() {
    str = this.allSongs.snapshots();
  }

  Stream<QuerySnapshot> get theStr => str;
}
