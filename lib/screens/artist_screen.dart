import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:ramp/api/audio_player.dart';
import 'package:ramp/api/audio_query.dart';
import 'package:ramp/controllers/songController.dart';

import 'now_playing.dart';

class ArtistScreen extends StatefulWidget {
  final ArtistModel artistModel;

  const ArtistScreen({Key? key, required this.artistModel}) : super(key: key);

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.artistModel.artist.toString()),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.more_vert_outlined))
          ],
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back))),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.30,
              // color: Colors.brown,
              child: Center(
                child: QueryArtworkWidget(
                    artworkWidth: MediaQuery.of(context).size.width * 0.4,
                    artworkHeight: MediaQuery.of(context).size.width * 0.4,
                    id: widget.artistModel.id,
                    type: ArtworkType.ARTIST,
                    artworkBorder: BorderRadius.circular(10)),
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 150,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: TextButton(
                        onPressed: () {},
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.play_arrow,
                              color: Colors.black,
                              size: 16,
                            ),
                            Text("Play",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      width: 150,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: TextButton(
                        onPressed: () {},
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.shuffle,
                              color: Colors.black,
                              size: 16,
                            ),
                            Text("Shuffle",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  height: MediaQuery.of(context).size.height * 0.70,
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.amber,
                  child: FutureBuilder<List<SongModel>>(
                    future: onAudioQuery.queryAudiosFrom(
                        AudiosFromType.ARTIST_ID, widget.artistModel.id),
                    builder:
                        (context, AsyncSnapshot<List<SongModel>> snapshot) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () async {
                              String? uri = snapshot.data![index].uri;
                              loadPlay(snapshot.data![index]);
                              // Get.to(() => NowPlayingScreen(
                              //     track: snapshot.data![index]));
                              setState(() {
                                // while (songPlayer.playing == true) {
                                isPlaying = songPlayer.playing;
                                // }
                                song = snapshot.data![index].title;
                              });
                              Get.find<songController>()
                                  .updateInfo(snapshot.data![index]);
                            },
                            title: Text(snapshot.data![index].title),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
