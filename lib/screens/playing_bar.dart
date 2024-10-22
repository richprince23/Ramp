import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:ramp/api/audio_query.dart';
import 'package:ramp/controllers/song_provider.dart';
import 'package:ramp/screens/now_playing.dart';
import 'package:ramp/styles/style.dart';

class PlayingBar extends StatefulWidget {
  const PlayingBar({super.key});

  @override
  State<PlayingBar> createState() => _PlayingBarState();
}

class _PlayingBarState extends State<PlayingBar> {
  @override
  void initState() {
    super.initState();
    // updateSong();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          Provider.of<SongProvider>(context, listen: false).getSong() != null
              ? Get.to(() => NowPlayingScreen())
              : null,
      child: Container(
        color: darkTheme.colorScheme.onSecondary,
        height: 50,
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Consumer<SongProvider>(
                    builder: (context, song, child) => song.getSong() != null
                        ? CircleAvatar(
                            radius: 20,
                            child: QueryArtworkWidget(
                                type: ArtworkType.AUDIO,
                                id: Provider.of<SongProvider>(context,
                                        listen: false)
                                    .getSong()!
                                    .id),
                          )
                        : const SizedBox.shrink(),
                  )),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<SongProvider>(
                  builder: ((context, song, child) => Text(
                        song.getSong() != null
                            ? song.getSong()!.title
                            : "Not Playing",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Consumer<SongProvider>(
                  builder: (context, song, child) => IconButton(
                    onPressed: () {
                      setState(() {
                        song.playing != true
                            ? songPlayer.play()
                            : songPlayer.pause();
                      });
                    },
                    icon: Icon(
                        song.playing != true ? Icons.play_arrow : Icons.pause),
                  ),
                ),
                Consumer<SongProvider>(
                  builder: (context, song, child) => IconButton(
                    onPressed: () {
                      setState(() {
                        if (songPlayer.hasNext == true) {
                          songPlayer.seekToNext();
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.skip_next,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
