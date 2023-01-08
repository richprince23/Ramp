import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:ramp/api/audio_query.dart';
import 'package:ramp/controllers/song_provider.dart';
import 'package:ramp/vars.dart';

//play song
// loadPlay(int index) {
//   songPlayer.setAudioSource(initialIndex: index, enqueue(queue));

//   songPlayer.play();
//   // Get.to(() => NowPlayingScreen(track: file));
// }
ConcatenatingAudioSource enqueue(List<SongModel>? data) {
  List<AudioSource> sources = [];

  for (SongModel song in data!) {
    sources.add(AudioSource.uri(Uri.parse(song.uri!)));
  }
  return ConcatenatingAudioSource(children: sources);
}

playMedia(BuildContext context, List<SongModel> list, int index) {
  // curQueue.clear();
  curQueue = list;
  if (curQueue.isNotEmpty) {
    songPlayer.setAudioSource(enqueue(curQueue),
        preload: true, initialIndex: index);
    songPlayer.play();
    // curTrack = curQueue[index];
    // isPlaying = songPlayer.playing;
    Provider.of<SongProvider>(context, listen: false).setSong(curQueue[index]);
    Provider.of<SongProvider>(context, listen: false).setIndex(index);
    Provider.of<SongProvider>(context, listen: false)
        .setPlaying(songPlayer.playing);
  }
}

playItem(BuildContext context, SongModel song) {
  // curQueue.clear();
  curQueue = [song];
  songPlayer.setAudioSource(
    AudioSource.uri(Uri.parse(song.uri!)),
    preload: true,
  );
  songPlayer.play();
  // curTrack = curQueue[index];
  // isPlaying = songPlayer.playing;
  Provider.of<SongProvider>(context, listen: false).setSong(song);
  Provider.of<SongProvider>(context, listen: false).setIndex(0);
  Provider.of<SongProvider>(context, listen: false)
      .setPlaying(songPlayer.playing);
}
