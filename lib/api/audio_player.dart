import 'package:just_audio/just_audio.dart';
import 'package:ramp/api/audio_query.dart';
import 'package:ramp/controllers/songController.dart';


//play song
loadPlay(int index) {
  songPlayer.setAudioSource(initialIndex: index, enqueue(queue));

  songPlayer.play();
  // Get.to(() => NowPlayingScreen(track: file));
}
