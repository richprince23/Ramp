import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../models/track.dart';

// class songController extends GetxController {
bool isPlaying = false;
String song = "".obs as String;
SongModel? track;
String artist = "";

// SongModel? trackModel;

// }
class songController extends GetxController {
  final track = Track().obs;

  updateInfo(SongModel curSong) {
    // song = trackModel!.displayNameWOExt;
    track.update((value) {
      value!.trackModel = curSong;
    });
  }
}
