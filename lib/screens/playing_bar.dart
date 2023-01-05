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
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: curTrack != null
                  ? CircleAvatar(
                      child: QueryArtworkWidget(
                          type: ArtworkType.AUDIO, id: curTrack!.id),
                    )
                  : CircleAvatar(),
            ),
          ],
        ),
      ),
    );
  }
}
