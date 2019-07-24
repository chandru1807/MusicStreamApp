import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:music_stream/models/playanimations.dart';
import 'package:music_stream/models/playanimations.dart' as prefix0;
import 'package:music_stream/models/player.dart';
import 'package:music_stream/models/player_state_model.dart';
import 'package:music_stream/pages/bottommusicbar.dart';
import 'package:music_stream/pages/musiccards.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '.././httpcalls/soundcloud.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Map<String, List<AnimationController>> iconMap;
  FlutterSound player;
  Playerr play;
  SharedPreferences sp;
  List<Map<String, String>> bigCardList = [
    {'text': 'Trending this week !!!', 'sub': 'Catch up with the trend x)'},
    {'text': 'Trending this week !!!', 'sub': 'Catch up with the trend x)'},
    {'text': 'Trending this week !!!', 'sub': 'Catch up with the trend x)'},
  ];
  String songNm;
  @override
  void initState() {
    super.initState();
    play = Playerr();
    player = FlutterSound();
    play.getAllSongs();
    iconMap = PlayAnimations.iconMap;
    //getMusicPlayer();
  }

  @override
  void dispose() {
    PlayAnimations().disposeIt();
    super.dispose();
  }

  // getMusicPlayer() async {
  //   sp = await SharedPreferences.getInstance();
  //   String val = sp.getString('player1');
  //   if (val == null) {
  //     player = FlutterSound();
  //   } else {
  //     player = FlutterSound(true);
  //   }
  // }

  CollectionReference allSongs = Firestore.instance.collection('/allSongs');
  final TextStyle bigCardBold = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
  );
  final TextStyle bigCardItalic = TextStyle(
    fontStyle: FontStyle.italic,
    fontSize: 13.0,
  );
  final TextStyle smallCardBold = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12.0,
  );
  final TextStyle smallCardItalic = TextStyle(
    fontStyle: FontStyle.italic,
    fontSize: 11.0,
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlayAnimations>(
      builder: (_) => PlayAnimations(),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
            ),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(
                    left: 10.0,
                    right: 20.0,
                    bottom: 20.0,
                    top: 20.0,
                  ),
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.horizontal(
                        left: const Radius.circular(10.0),
                        right: Radius.circular(10.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Center(
                      child: TextFormField(
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                          border: InputBorder.none,
                          suffixIcon: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 180.0,
                  child: ListView.builder(
                    itemCount: 3,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      AnimationController anime = AnimationController(
                        vsync: this,
                        duration: Duration(milliseconds: 400),
                      );

                      iconMap['bigCard'] == null
                          ? iconMap['bigCard'] = [anime]
                          : iconMap['bigCard'].add(anime);
                      return Container(
                        height: 180.0,
                        margin: EdgeInsets.only(bottom: 2.0),
                        child: MusCardStyle(
                          text: bigCardList[index]['text'],
                          sub: bigCardList[index]['sub'],
                          imgUrl: 'https://picsum.photos/280/130',
                          height: 130.0,
                          width: 280.0,
                          sizedBoxheight: 40.0,
                          boldT: bigCardBold,
                          italicT: bigCardItalic,
                          animeMap: iconMap,
                          index: index,
                          cardStr: 'bigCard',
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'All Songs',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.75),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {},
                      child: Text(
                        'View all',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  height: 150.0,
                  //margin: EdgeInsets.only(bottom: 20.0),
                  child: StreamBuilder(
                    stream: play.theStr,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshots) {
                      if (snapshots.hasData) {
                        iconMap['allSongs'] = [];
                        return ListView.builder(
                          //padding: EdgeInsets.only(bottom: 2.0),
                          itemCount: 6,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, int index) {
                            AnimationController anime = AnimationController(
                              vsync: this,
                              duration: Duration(milliseconds: 400),
                            );
                            iconMap['allSongs'].add(anime);
                            return Container(
                              height: 145.0,
                              margin: EdgeInsets.only(bottom: 2.0),
                              child: InkWell(
                                onTap: () {},
                                child: new MusCardStyle(
                                  text: snapshots
                                      .data.documents[index].data['songTitle'],
                                  sub: snapshots
                                      .data.documents[index].data['genre'],
                                  imgUrl: snapshots.data.documents[index]
                                      .data['musicImgUrl'],
                                  height: 100.0,
                                  width: 120.0,
                                  sizedBoxheight: 35.0,
                                  boldT: smallCardBold,
                                  italicT: smallCardItalic,
                                  animeMap: iconMap,
                                  index: index,
                                  cardStr: 'allSongs',
                                  docRef: snapshots.data.documents[index],
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshots.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'All Songs',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.75),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {},
                      child: Text(
                        'View all',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                MaterialButton(
                  onPressed: () {
                    player.stopPlayer();
                  },
                  child: Text(
                    'stop',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: Text(
                    'logout',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          PlayAnimations.songNm != null
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.orange,
                    width: MediaQuery.of(context).size.width,
                    height: 40.0,
                    child: BottomMusicBar(),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
