import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_stream/pages/prefspage.dart';
import 'package:music_stream/pages/mainpage.dart';
import 'package:music_stream/pages/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/playanimations.dart';

void main() => runApp(
      MaterialApp(
        home: new AuthCheck(),
        debugShowCheckedModeBanner: false,
        title: "Music Stream",
        routes: {
          '/mainPage': (context) => MainPage(),
          '/prefPage': (context) => PrefPage(),
        },
      ),
    );

class AuthCheck extends StatefulWidget {
  const AuthCheck({
    Key key,
  }) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  Widget showWidget;
  @override
  void initState() {
    initPlayerState();
    checkFirstTime().then((onValue) {
      setState(() {
        showWidget = onValue;
      });
    });
    super.initState();
  }

  initPlayerState() async {
    var prefs = await SharedPreferences.getInstance();
    //uId = prefs.getString('user_id');
    String state = prefs.getString('player_state');
    if (state != null) {
      Map pState = json.decode(state);
      PlayAnimations.prevIndex = pState['playIndex'];
      PlayAnimations.prevStr = pState['cardStr'];
      PlayAnimations.isPlaying = pState['isPlaying'];
      PlayAnimations.songNm = pState['playStr'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasData) {
            checkFirstTime().then((onValue) {
              if (showWidget == null) {
                setState(() {
                  showWidget = onValue;
                });
              }
            });
            return showWidget ??
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
          } else {
            return Material(child: SignUp());
          }
        }
      },
    );
  }

  Future<Widget> checkFirstTime() async {
    var prefs = await SharedPreferences.getInstance();
    String uId = prefs.getString('user_id');
    print(uId);
    if (uId != null) {
      DocumentReference ref =
          Firestore.instance.collection('UserDetails').document(uId);
      DocumentSnapshot snap = await ref.get();
      if (snap.data['prefs'] != null) {
        return MainPage();
      } else {
        return PrefPage();
      }
    }
    return null;
  }
}
