import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_stream/models/playanimations.dart';
import 'package:music_stream/models/player_state_model.dart';
import 'package:music_stream/models/preferences.dart';
import 'package:music_stream/pages/circlerows.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PrefPage extends StatefulWidget {
  @override
  _PrefPageState createState() => _PrefPageState();
}

class _PrefPageState extends State<PrefPage> {
  ScrollController _sCont;
  bool _showSkip = true;
  bool _initialScroll = false;
  String uId;
  CollectionReference doc = Firestore.instance.collection('UserDetails');
  @override
  void initState() {
    _sCont = ScrollController()..addListener(_scrollListn);
    super.initState();
    getUserId();
    //checkFirstTime();
  }

  getUserId() async {
    var prefs = await SharedPreferences.getInstance();
    uId = prefs.getString('user_id');
  }
  // checkFirstTime() async {
  //   var prefs = await SharedPreferences.getInstance();
  //   uId = prefs.getString('user_id');
  //   print(uId);
  //   if (uId != null) {
  //     DocumentReference ref = doc.document(uId);
  //     DocumentSnapshot snap = await ref.get();
  //     if (snap.data['prefs'] != null) {
  //       Navigator.of(context).pushReplacementNamed('/mainPage');
  //     }
  //   }
  // }

  _scrollListn() {
    if (_sCont.offset >= _sCont.position.maxScrollExtent &&
        !_sCont.position.outOfRange) {
      _initialScroll = true;
      setState(() {
        _showSkip = false;
      });
    } else {
      if (_initialScroll) {
        setState(() {
          _showSkip = true;
        });
        _initialScroll = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Stack(
          children: <Widget>[
            ListView(
              controller: _sCont,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'Customise your Experience',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(
                      width: 32.0,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/mainPage');
                      },
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Language',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.75),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: 100.0,
                  child: CircleRows('music_lang'),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Composers',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.75),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: 100.0,
                  child: CircleRows('composers'),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Singers',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.75),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: 100.0,
                  child: CircleRows('singers'),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Years',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.75),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: 100.0,
                  child: CircleRows('years'),
                ),
                SizedBox(
                  height: 200.0,
                ),
                RaisedButton(
                  color: Colors.greenAccent,
                  clipBehavior: Clip.antiAlias,
                  onPressed: () {
                    doc.document(uId).updateData({'prefs': Pref().getPrefMap});
                    Navigator.of(context).pushReplacementNamed('/mainPage');
                  },
                  child: Text('Let\'s get started !!'),
                ),
              ],
            ),
            _showSkip
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () => Navigator.of(context)
                          .pushReplacementNamed('/mainPage'),
                      child: Container(
                        child: Text('Skip this step'),
                        alignment: Alignment.center,
                        height: 50.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 5.0,
                            ),
                          ],
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        margin: EdgeInsets.only(
                          bottom: 10.0,
                        ),
                        //color: Colors.orange,
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
