import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Track {
  Track(
      {this.isPlaying = false,
      this.artist = "",
      this.artwork,
      this.song,
      this.trackModel});

  bool isPlaying;
  String? song;
  String? artist;
  Widget? artwork;
  SongModel? trackModel;
}
