import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:ramp/controllers/songController.dart';
import 'package:ramp/models/track.dart';
import 'package:ramp/screens/now_playing.dart';

final AudioPlayer songPlayer = AudioPlayer();

loadPlay(SongModel file) {
  songPlayer.setAudioSource(AudioSource.uri(Uri.parse(file.uri!)));
  Track(trackModel: file);
  
  track = file;
  songPlayer.play();
  // Get.to(() => NowPlayingScreen(track: file));
}
