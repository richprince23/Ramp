import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:ramp/api/audio_query.dart';
import 'package:ramp/controllers/songController.dart';
import 'package:ramp/controllers/song_provider.dart';
import 'package:ramp/vars.dart';

//play song
loadPlay(int index) {
  songPlayer.setAudioSource(initialIndex: index, enqueue(queue));

  songPlayer.play();
  // Get.to(() => NowPlayingScreen(track: file));
}

playMedia(BuildContext context, List<SongModel> list, int index) {
  curQueue = list;
  if (curQueue.isNotEmpty) {
    songPlayer.setAudioSource(enqueue(curQueue),
        preload: true, initialIndex: index);
    songPlayer.play();
    // curTrack = curQueue[index];
    Provider.of<SongProvider>(context, listen: false).setSong(curQueue[index]);
    Provider.of<SongProvider>(context, listen: false).setIndex(index);
    isPlaying = songPlayer.playing;
  } else {
    print("HTHE QUEUE IS EMPTY \N\N\N\N\N");
  }
}
