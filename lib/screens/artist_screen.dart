import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:ramp/api/audio_player.dart';
import 'package:ramp/api/audio_query.dart';
import 'package:ramp/controllers/songController.dart';
import 'package:ramp/vars.dart';
import 'package:ramp/widgets/playing_panel.dart';

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
          leading: const BackButton()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
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
                      if (snapshot.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasData) {
                        queue.clear();
                        queue = snapshot.data!;
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () async {
                                setState(() {
                                  isPlaying = songPlayer.playing;
                                  // curIndex = index;
                                });
                                Get.find<songController>()
                                    .setSong(snapshot.data![index]);
                                loadPlay(index);
                              },
                              title: Text(snapshot.data![index].title),
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: Text("No songs found"),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      persistentFooterButtons: const [NowPlayingPanel()],
    );
  }
}
