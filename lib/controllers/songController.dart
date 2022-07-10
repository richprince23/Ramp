import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../models/track.dart';

// class songController extends GetxController {
bool isPlaying = false;

SongModel? track;

String artist = "";

// SongModel? trackModel;

// }
class songController extends GetxController {
  // final track = Track().obs;
  String song = "";
  SongModel? curTrack;
  bool isPlaying = false;
  int does = 0;

  setSong(SongModel this_song) {
    song = this_song.title;
    curTrack = this_song;
    does++;
    bool isPlaying = true;
    update();
  }
}
