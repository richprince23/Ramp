import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:ramp/api/audio_player.dart';
import 'package:ramp/controllers/songController.dart';
import '../api/audio_query.dart';
import '../custom.dart';

class AllSongsScreen extends StatefulWidget {
  const AllSongsScreen({Key? key}) : super(key: key);

  @override
  State<AllSongsScreen> createState() => _AllSongsScreenState();
}

class _AllSongsScreenState extends State<AllSongsScreen> {
  songController trackController = Get.put<songController>(songController());
  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    getAcess();
    songPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        updateIndex(index);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // songPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SongModel>>(
      future: onAudioQuery.querySongs(
        ignoreCase: true,
        orderType: OrderType.DESC_OR_GREATER,
        sortType: null,
        uriType: Platform.isAndroid ? UriType.EXTERNAL : UriType.INTERNAL,
      ),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          // setState(() {
          queue.clear();
          queue = snapshot.data!;
          // });
          return ListView.builder(
              padding: const EdgeInsets.only(bottom: 40),
              itemCount: snapshot.data!.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  onTap: () async {
                    // String? uri = snapshot.data![index].uri;
                    setState(() {
                      isPlaying = songPlayer.playing;
                      // curIndex = index;
                    });
                    Get.find<songController>().setSong(snapshot.data![index]);
                    loadPlay(index);
                  },
                  trailing: IconButton(
                      icon: const Icon(Icons.more_horiz_outlined),
                      onPressed: () {
                        // add to favorites
                      }),
                  title: Row(
                    children: [
                      Flexible(
                        child: Text(snapshot.data![index].title,
                            style: const TextStyle(
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis)),
                      ),
                    ],
                  ),
                  subtitle:
                      Text(snapshot.data![index].artist ?? "Unknown Artiste"),
                  leading: QueryArtworkWidget(
                      id: snapshot.data![index].id, type: ArtworkType.AUDIO),
                );
              }));
        } else {
          return const Center(
            child: Text("No songs found"),
          );
        }
      },
    );
  }

  void updateIndex(int index) {
    setState(() {
      if (queue.isNotEmpty) {
        trackController.setSong(queue[index]);
        // curIndex = index;
      }
    });
  }
}
