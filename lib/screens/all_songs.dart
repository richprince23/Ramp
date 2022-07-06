import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:ramp/api/audio_player.dart';
import 'package:ramp/controllers/songController.dart';
import 'package:ramp/models/track.dart';
import '../api/audio_query.dart';
import '../custom.dart';
import 'now_playing.dart';

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
    // TODO: implement initState
    super.initState();
    getAcess();
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
          uriType: UriType.EXTERNAL),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          return ListView.builder(
              padding: const EdgeInsets.only(bottom: 40),
              itemCount: snapshot.data!.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  onTap: () async {
                    String? uri = snapshot.data![index].uri;
                    loadPlay(snapshot.data![index]);
                    // Get.to(
                    //     () => NowPlayingScreen(track: snapshot.data![index]));
                    setState(() {
                      // while (songPlayer.playing == true) {
                      isPlaying = songPlayer.playing;
                      // }
                      song = snapshot.data![index].title;
                    });
                    Get.find<songController>()
                        .updateInfo(snapshot.data![index]);
                  },
                  trailing: IconButton(
                      icon: Icon(Icons.more_horiz_outlined),
                      onPressed: () {
                        // add to favorites
                      }),
                  title: Text(snapshot.data![index].title,
                      style: TextStyle(color: Colors.white)),
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
}
