import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:ramp/api/audio_player.dart';
import 'package:ramp/models/track.dart';
import 'package:ramp/styles/style.dart';

import '../controllers/songController.dart';
import '../screens/now_playing.dart';

class NowPlayingPanel extends StatefulWidget {
  String file;

  NowPlayingPanel({Key? key, required this.file}) : super(key: key);

  @override
  State<NowPlayingPanel> createState() => _NowPlayingPanelState();
}

class _NowPlayingPanelState extends State<NowPlayingPanel> {
  songController trackController = Get.put<songController>(songController());

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (BuildContext context) {
        return InkWell(
            onTap: () {
              Get.to(() => NowPlayingScreen(track: track!),
                  transition: Transition.downToUp,
                  duration: Duration(milliseconds: 500));
            },
            child: Container(
              height: MediaQuery.of(context).size.height / 12,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(20),
                color: darkTheme.colorScheme.onSecondary,
                // color: Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        CircleAvatar(
                          radius: 20,
                          foregroundImage: null,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Flexible(
                            child: Text(
                          widget.file.toString(),
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                          softWrap: false,
                        )),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            print("play");
                          },
                          icon: Icon(Icons.play_arrow_rounded)),
                      IconButton(
                          onPressed: () {
                            print("next");
                          },
                          icon: Icon(Icons.skip_next_rounded)),
                    ],
                  ),
                ],
              ),
              // ),
            ));
      },
      onClosing: () {},
    );
  }
}
