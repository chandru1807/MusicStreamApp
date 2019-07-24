import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:music_stream/models/playanimations.dart';
import 'package:music_stream/models/player.dart';
import 'package:provider/provider.dart';

class BottomMusicBar extends StatefulWidget {
  @override
  _BottomMusicBarState createState() => _BottomMusicBarState();
}

class _BottomMusicBarState extends State<BottomMusicBar>
    with SingleTickerProviderStateMixin {
  AnimationController anime;
  static FlutterSound player;
  var name;
  @override
  void initState() {
    super.initState();
    anime = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    player = Playerr.player;
  }

  pauseIt() async {
    await player.pausePlayer();
    // PlayerState pState =
    //     PlayerState(this.widget.index, this.widget.text, false);

    setPlayerState(false);
  }

  resumeIt() async {
    await player.resumePlayer();
    setPlayerState(true);
  }

  setPlayerState(bool isPlaying) {
    name.setPlay = isPlaying;
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    name = Provider.of<PlayAnimations>(context);
    name.playState ? anime.forward() : anime.reverse();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(Icons.favorite_border),
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Center(
            child: Text(
              name.songName,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.play_pause,
            progress: anime,
            size: 28.0,
            color: Colors.black,
          ),
          onPressed: () {
            if (name.playState) {
              pauseIt();
              if (PlayAnimations.iconMap[PlayAnimations.prevStr].length >
                  PlayAnimations.prevIndex) {
                PlayAnimations.iconMap[PlayAnimations.prevStr]
                        [PlayAnimations.prevIndex]
                    .reverse();
              }
            } else {
              if (PlayAnimations.iconMap[PlayAnimations.prevStr].length >
                  PlayAnimations.prevIndex) {
                PlayAnimations.iconMap[PlayAnimations.prevStr]
                        [PlayAnimations.prevIndex]
                    .forward();
              }
              resumeIt();
            }
          },
        ),
      ],
    );
  }
}
