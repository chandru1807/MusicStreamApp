import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future addToCloud(String track) async {
  final response =
      await http.get('http://192.168.0.196:8000/ooo/users/' + track);
  if (response != null) {
    print(json.decode(response.body));
    var val = json.decode(response.body);
    val['trackId'] = track;
    val['songUrl'] =
        val['songUrl'] + '?client_id=MpLVGIOGWboHqGT3WePdQvUOVd0sswgq';
    //print(val['songUrl']);
    var db = Firestore.instance.collection('allSongs');
    db.add(val);
    Map saveMap = Map.from(val);
    print(saveMap);
  }
}
