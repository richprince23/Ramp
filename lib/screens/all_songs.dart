import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:ramp/api/audio_player.dart';
import 'package:ramp/controllers/song_provider.dart';
import 'package:ramp/vars.dart';

class AllSongsScreen extends StatefulWidget {
  const AllSongsScreen({Key? key}) : super(key: key);

  @override
  State<AllSongsScreen> createState() => _AllSongsScreenState();
}

class _AllSongsScreenState extends State<AllSongsScreen> {
  @override
  void initState() {
    // getSongs();
    super.initState();
    // updateSong();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            // color: darkTheme.backgroundColor,
            padding: const EdgeInsets.all(4),
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    await playMedia(context, allSongs, 0);
                  },
                  icon: Icon(Icons.play_arrow),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  label: Text(
                    "Play All",
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await playMedia(context, allSongs,
                        Random().nextInt(allSongs.length ),
                        shuffle: true);
                  },
                  icon: Icon(Icons.shuffle),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  label: Text(
                    "Shuffle",
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.70,
            child: buildAllSongs(),
          ),
          // buildAllSongs(),
        ],
      ),
    );
  }

  FutureBuilder<List<SongModel>> buildAllSongs() {
    return FutureBuilder<List<SongModel>>(
      future: getSongs(),
      initialData: allSongs,
      builder: (context, AsyncSnapshot<List<SongModel>> snapshot) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          allArtistesSongs = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async => setState(() {
              getSongs();
            }),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              cacheExtent: 400,
              itemBuilder: (context, index) {
                return Slidable(
                  startActionPane:
                      ActionPane(motion: const StretchMotion(), children: [
                    SlidableAction(
                        onPressed: ((context) {
                          print("hey");
                        }),
                        icon: Icons.playlist_add),
                  ]),
                  endActionPane:
                      ActionPane(motion: const StretchMotion(), children: [
                    SlidableAction(
                      foregroundColor: Colors.red,
                      onPressed: ((context) {
                        print("hey");
                      }),
                      icon: Icons.favorite_outline,
                    ),
                  ]),
                  child: ListTile(
                    onTap: () async {
                      // playMedia(context, allArtistesSongs, index);
                      playItem(context, snapshot.data![index]);
                    },
                    trailing: Consumer<SongProvider>(
                      builder: (context, song, child) => IconButton(
                          icon: Icon(index ==
                                  Provider.of<SongProvider>(context,
                                          listen: false)
                                      .index
                              ? Icons.play_arrow
                              : null),
                          color: Colors.pinkAccent,
                          onPressed: () {
                            // add to favorites
                          }),
                    ),
                    title: Text(
                        snapshot.data![index].title == ""
                            ? snapshot.data![index].displayNameWOExt
                            : snapshot.data![index].title,
                        style: const TextStyle(
                            fontSize: 16, overflow: TextOverflow.ellipsis)),
                    subtitle: Text(
                      snapshot.data![index].artist ?? "Unknown Artist",
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: QueryArtworkWidget(
                            artworkBorder: BorderRadius.circular(0),
                            id: snapshot.data![index].id,
                            type: ArtworkType.AUDIO) ??
                        SizedBox.shrink(),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: Text("No songs found"),
          );
        }
      },
    );
  }
}
