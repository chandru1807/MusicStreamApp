import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:music_stream/models/preferences.dart';

class CircleRows extends StatefulWidget {
  final String doc;
  CircleRows(this.doc);
  @override
  _CircleRowsState createState() => _CircleRowsState();
}

class _CircleRowsState extends State<CircleRows> {
  Map selMap = Map();
  String _callStr = '';
  static Pref pref = Pref();
  @override
  Widget build(BuildContext context) {
    CollectionReference db = Firestore.instance.collection(widget.doc);
    if (widget.doc == 'music_lang') {
      _callStr = 'language';
    } else if (widget.doc == 'composers') {
      _callStr = 'composer';
    } else if (widget.doc == 'singers') {
      _callStr = 'singer';
    } else {
      _callStr = 'yearRange';
    }
    return StreamBuilder(
      stream: _callStr != 'yearRange'
          ? db.snapshots()
          : db.orderBy('yearRange').snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshots) {
        if (snapshots.hasData) {
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshots.data.documents.length,
              itemBuilder: (context, index) {
                String data = _callStr != 'yearRange'
                    ? snapshots.data.documents[index].data[_callStr]
                    : snapshots.data.documents[index].data[_callStr]
                            .toString() +
                        's';
                return GestureDetector(
                  onTap: () {
                    checkInMap(data);
                  },
                  child: InkWell(
                    onTap: null,
                    child: Container(
                      child: Text(
                        data,
                        style: TextStyle(
                            color: selMap.containsKey(data)
                                ? Colors.white
                                : Colors.black),
                      ),
                      height: 100.0,
                      width: 100.0,
                      margin: EdgeInsets.only(right: 10.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5.0,
                          ),
                        ],
                        color: selMap.containsKey(data)
                            ? Color(selMap[data]).withOpacity(1.0)
                            : Colors.white,
                        shape: BoxShape.circle,
                        gradient: selMap.containsKey(data)
                            ? LinearGradient(
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft,
                                colors: [
                                  Colors.white.withOpacity(0.3),
                                  Color(selMap[data]).withOpacity(1.0),
                                ],
                              )
                            : null,
                        border: Border.all(
                          width: 1.0,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                );
              });
        } else if (snapshots.hasError) {
          print(snapshots.error.toString());
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  void checkInMap(String val) {
    if (selMap.containsKey(val)) {
      selMap.remove(val);
    } else {
      selMap[val] = (math.Random().nextDouble() * 0xFFFFFF).toInt() << 0;
    }
    Map tempMap = pref.getPrefMap;
    tempMap[_callStr] = selMap;
    pref.setPrefMap = tempMap;
    print(pref.getPrefMap);
    setState(() {});
  }
}
