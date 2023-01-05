import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:ramp/api/audio_player.dart';
import 'package:ramp/controllers/songController.dart';
import 'package:ramp/controllers/song_provider.dart';
import 'package:ramp/vars.dart';
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
        // Provider.of<SongProvider>(context, listen: false).setIndex(index);
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
    return buildSongs(allSongs);
  }

  RefreshIndicator buildSongs(List<SongModel> snapshot) {
    return RefreshIndicator(
      onRefresh: () async {
        allSongs = await getSongs();
        // setState(() {});
      },
      child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 40),
          itemCount: snapshot.length,
          cacheExtent: 20,
          itemBuilder: ((context, index) {
            return ListTile(
              onTap: () {
                playMedia(context, allSongs, index);
              },
              trailing: IconButton(
                  icon: const Icon(Icons.more_horiz_outlined),
                  onPressed: () {
                    // add to favorites
                  }),
              title: Row(
                children: [
                  Flexible(
                    child: Text(snapshot[index].title,
                        style: const TextStyle(
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis)),
                  ),
                ],
              ),
              subtitle: Text(snapshot[index].artist ?? "Unknown Artiste"),
              leading: QueryArtworkWidget(
                  id: snapshot[index].id, type: ArtworkType.AUDIO),
            );
          })),
    );
  }

  void updateIndex(int index) {
    // setState(() {
    if (queue.isNotEmpty) {
      trackController.setSong(queue[index]);
      // curIndex = index;
    }
    // });
  }
}
