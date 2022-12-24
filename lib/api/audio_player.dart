import 'package:just_audio/just_audio.dart';
import 'package:ramp/controllers/songController.dart';

final AudioPlayer songPlayer = AudioPlayer();

loadPlay(int index) {
  songPlayer.setAudioSource(initialIndex: index, enqueue(queue));

  songPlayer.play();
  // Get.to(() => NowPlayingScreen(track: file));
}
