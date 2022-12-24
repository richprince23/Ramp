import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

// class songController extends GetxController {
bool isPlaying = false;

List<SongModel> queue = [];
// int curIndex = 0;

ConcatenatingAudioSource enqueue(List<SongModel>? data) {
  List<AudioSource> sources = [];

  for (SongModel song in queue) {
    sources.add(AudioSource.uri(Uri.parse(song.uri!)));
  }
  return ConcatenatingAudioSource(children: sources);
}

class songController extends GetxController {
  String song = "";
  SongModel? curTrack;
  bool isPlaying = false;
  int does = 0;
  int curIndex = 0;
  setSong(SongModel this_song) {
    song = this_song.title;
    curTrack = this_song;
    curIndex = this_song.id;
    isPlaying = true;
    update();
  }
}
