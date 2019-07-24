import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:music_stream/models/playanimations.dart';
import 'package:music_stream/models/player.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusCardStyle extends StatefulWidget {
  MusCardStyle({
    Key key,
    @required this.text,
    @required this.sub,
    @required this.imgUrl,
    @required this.height,
    @required this.width,
    @required this.sizedBoxheight,
    @required this.boldT,
    @required this.italicT,
    @required this.animeMap,
    @required this.index,
    @required this.cardStr,
    this.docRef,
  }) : super(key: key);

  final String text;
  final String sub;
  final String imgUrl;
  final double height;
  final double width;
  final double sizedBoxheight;
  final TextStyle boldT;
  final TextStyle italicT;
  final Map animeMap;
  final int index;
  final String cardStr;
  final DocumentSnapshot docRef;

  @override
  _MusCardStyleState createState() => _MusCardStyleState();
}

class _MusCardStyleState extends State<MusCardStyle> {
  static FlutterSound player;
  SharedPreferences sp;
  var play;
  @override
  void initState() {
    super.initState();
    player = Playerr.player;
    initSp();
  }

  initSp() async {
    //player = await Playerr().player1();
    if (sp == null) {
      sp = await SharedPreferences.getInstance();
    }
    if (this.widget.text == PlayAnimations.songNm) {
      PlayAnimations.prevIndex = this.widget.index;
      if (PlayAnimations.isPlaying) {
        this.widget.animeMap[this.widget.cardStr][this.widget.index].forward();
      }
    }
  }

  Future<String> stopIt() {
    return _MusCardStyleState.player.stopPlayer();
  }

  resumeIt() async {
    await _MusCardStyleState.player.resumePlayer();
    setPlayerState(true);
  }

  pauseIt() async {
    await _MusCardStyleState.player.pausePlayer();
    // PlayerState pState =
    //     PlayerState(this.widget.index, this.widget.text, false);

    setPlayerState(false);
  }

  playIt(String url) async {
    await _MusCardStyleState.player.startPlayer(url);
    //print(json.encode(player));
    //PlayerState pState = PlayerState(this.widget.index, this.widget.text, true);
    setPlayerState(true);
    //setState(() {});
    //player.stopPlayer();
  }

  setPlayerState(bool isPlaying) {
    Map pState = Map();
    pState['playIndex'] = this.widget.index;
    pState['playStr'] = this.widget.text;
    pState['cardStr'] = this.widget.cardStr;
    pState['isPlaying'] = isPlaying;
    sp.setString('player_state', json.encode(pState));
    play.setSong = pState['playStr'];
    play.setPlay = pState['isPlaying'];
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    play = Provider.of<PlayAnimations>(context);
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: this.widget.height,
                width: this.widget.width,
                decoration: BoxDecoration(
                  //color: Colors.amber,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      10.0,
                    ),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(this.widget.imgUrl),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                height: this.widget.sizedBoxheight,
                width: this.widget.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      this.widget.text,
                      overflow: TextOverflow.ellipsis,
                      style: this.widget.boldT,
                    ),
                    Text(
                      this.widget.sub,
                      overflow: TextOverflow.ellipsis,
                      style: this.widget.italicT,
                    )
                  ],
                ),
                // child: ListTile(
                //   title: Text(
                //     text,
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                //   subtitle: Text(
                //     sub,
                //     style: TextStyle(
                //       fontStyle: FontStyle.italic,
                //     ),
                //   ),
                // ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -1.0,
          right: -1.0,
          child: Container(
            height: 27.0,
            width: 27.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: Colors.orange,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -12.0,
          right: -12.0,
          child: IconButton(
            icon: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: this.widget.animeMap[this.widget.cardStr]
                  [this.widget.index],
              size: 28.0,
              color: Colors.orange,
            ),
            onPressed: () {
              if (PlayAnimations.prevIndex != null &&
                  (this.widget.cardStr == PlayAnimations.prevStr) &&
                  (this.widget.index == PlayAnimations.prevIndex)) {
                if (this
                        .widget
                        .animeMap[this.widget.cardStr][this.widget.index]
                        .status ==
                    AnimationStatus.dismissed) {
                  if (this.widget.animeMap[this.widget.cardStr].length >
                      this.widget.index) {
                    this
                        .widget
                        .animeMap[this.widget.cardStr][this.widget.index]
                        .forward();
                  }
                  resumeIt();
                } else if (this
                        .widget
                        .animeMap[this.widget.cardStr][this.widget.index]
                        .status ==
                    AnimationStatus.completed) {
                  pauseIt();
                  if (this.widget.animeMap[this.widget.cardStr].length >
                      this.widget.index) {
                    this
                        .widget
                        .animeMap[this.widget.cardStr][this.widget.index]
                        .reverse();
                  }
                }
              } else {
                if (PlayAnimations.prevIndex != null) {
                  stopIt()
                      .then((onValue) =>
                          playIt(this.widget.docRef.data['songUrl']))
                      .catchError((onError) =>
                          playIt(this.widget.docRef.data['songUrl']));
                  if (this.widget.animeMap[PlayAnimations.prevStr].length >
                      PlayAnimations.prevIndex) {
                    this
                        .widget
                        .animeMap[PlayAnimations.prevStr]
                            [PlayAnimations.prevIndex]
                        .reverse();
                  }
                } else {
                  playIt(this.widget.docRef.data['songUrl']);
                }
                if (this.widget.animeMap[this.widget.cardStr].length >
                    this.widget.index) {
                  this
                      .widget
                      .animeMap[this.widget.cardStr][this.widget.index]
                      .forward();
                }

                PlayAnimations.prevIndex = this.widget.index;
              }
              PlayAnimations.songNm = this.widget.text;
              PlayAnimations.prevStr = this.widget.cardStr;
              //setState(() {});
            },
          ),
        ),
        Positioned(
          top: 1.0,
          right: -1.0,
          child: Container(
            height: 27.0,
            width: 27.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: Colors.orange,
              ),
            ),
          ),
        ),
        Positioned(
          top: 1.0,
          right: -1.0,
          child: Container(
            height: 27.0,
            width: 27.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: Colors.orange,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
