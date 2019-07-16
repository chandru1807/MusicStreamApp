class PlayerState {
  int playIndex;
  String playStr;
  bool isPlaying;

  PlayerState(this.playIndex, this.playStr, this.isPlaying);

  Map toJson() {
    Map map = Map();
    map['playIndex'] = this.playIndex;
    map['playStr'] = this.playStr;
    map['isPlaying'] = this.isPlaying;
    return map;
  }

  // fromJson(Map map){
  //   this
  // }
}
