//import 'package:anim_tut/providers/user_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email, _password;
  CollectionReference doc = Firestore.instance.collection('UserDetails');
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(
                  Icons.account_box,
                ),
              ),
              validator: (String eId) {
                if (eId.length == 0) {
                  return 'Enter email';
                }
              },
              onSaved: (String value) {
                _email = value;
              },
            ),
            TextFormField(
              autofocus: false,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'password',
                prefixIcon: Icon(
                  Icons.access_alarms,
                ),
              ),
              validator: (String eId) {
                if (eId.length == 0) {
                  return 'Enter password';
                }
              },
              onSaved: (String value) {
                _password = value;
              },
            ),
            RaisedButton(
              onPressed: () {
                signIn();
              },
              child: Text('Sign in'),
            ),
            RaisedButton(
              child: Text('Sign Up'),
              onPressed: () {
                signUp();
              },
              splashColor: Colors.orange,
            ),
            RaisedButton(
              onPressed: () {
                googSignin();
              },
              child: Text('Google sign in'),
            ),
          ],
        ),
      ),
    );
  }

  void signIn() async {
    FormState _state = _formKey.currentState;
    _state.save();
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      FirebaseUser user = await auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      //UserDet().userId = user.uid;
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('user_id', user.uid);
      print(user);
    } catch (e) {
      print(e);
    }
  }

  void signUp() async {
    FormState _state = _formKey.currentState;
    if (_state.validate()) {
      print('validated');
      _state.save();
      FirebaseAuth auth = FirebaseAuth.instance;
      try {
        FirebaseUser user = await auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        var prefs = await SharedPreferences.getInstance();
        prefs.setString('user_id', user.uid);
        Map<String, dynamic> data = {
          'id': user.uid,
          'emailId': user.email,
          'displayName': user.displayName
        };
        doc.document(user.uid).setData(data);
        //UserDet().userId = user.uid;
        print(user);
      } catch (e) {
        print(e);
      }

      //TODO firbase call
    }
  }

  void googSignin() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user = await _auth.signInWithCredential(credential);
      Map<String, dynamic> data = {
        'id': user.uid,
        'emailId': user.email,
        'displayName': user.displayName,
      };
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('user_id', user.uid);
      doc.document(user.uid).setData(data, merge: true);
      //UserDet().userId = user.uid;
      print(user);
    } catch (e) {
      print(e);
    }
  }
}
