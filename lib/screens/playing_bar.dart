import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:ramp/api/audio_query.dart';
import 'package:ramp/controllers/song_provider.dart';
import 'package:ramp/screens/now_playing.dart';
import 'package:ramp/vars.dart';

class PlayingBar extends StatefulWidget {
  const PlayingBar({super.key});

  @override
  State<PlayingBar> createState() => _PlayingBarState();
}

class _PlayingBarState extends State<PlayingBar> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => NowPlayingScreen()),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Consumer<SongProvider>(builder: ((context, song, child) {
          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: song.getSong() != null
                      ? CircleAvatar(
                          radius: 20,
                          child: QueryArtworkWidget(
                              type: ArtworkType.AUDIO, id: curTrack!.id),
                        )
                      : CircleAvatar(),
                ),
              ),
              Expanded(flex: 3, child: Text(song.getSong()!.title)),
              Builder(builder: (context) {
                return IconButton(
                    onPressed: () {
                      isPlaying == true
                          ? songPlayer.pause()
                          : songPlayer.play();
                      setState(() {
                        isPlaying = !isPlaying;
                      });
                    },
                    icon: Provider.of<SongProvider>(context).playing
                        ? Icon(Icons.pause)
                        : Icon(Icons.play_arrow));
              }),
            ],
          );
        })),
      ),
    );
  }
}
