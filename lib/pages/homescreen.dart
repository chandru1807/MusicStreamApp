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
    PlayAnimations().dispose();
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
    return Stack(
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
                      child: new MusCardStyle(
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
                                imgUrl: snapshots
                                    .data.documents[index].data['musicImgUrl'],
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
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.black,
            width: MediaQuery.of(context).size.width,
            height: 40.0,
          ),
        ),
      ],
    );
  }
}

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
  }

  @override
  Widget build(BuildContext context) {
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
