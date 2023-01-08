import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:ramp/api/audio_player.dart';
import 'package:ramp/controllers/song_provider.dart';
import 'package:ramp/screens/playing_bar.dart';
import 'package:ramp/vars.dart';

class ArtistScreen extends StatefulWidget {
  // final ArtistModel artistModel;

  final int artisteId;
  late String? artistName;
  // ArtistScreen({Key? key, required this.artistModel, })
  ArtistScreen({Key? key, required this.artisteId, this.artistName})
      : super(key: key);

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  String? artistName;

  @override
  Widget build(BuildContext context) {
    // artistName = getArtisteModel(widget.artisteId);
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.artistName ?? "Artist"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.more_vert_outlined))
          ],
          leading: const BackButton()),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
                    id: widget.artisteId,
                    type: ArtworkType.ARTIST,
                    artworkBorder: BorderRadius.circular(10)),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        await playMedia(context, allArtistesSongs, 0);
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
                        await playMedia(context, allSongs, 0, shuffle: true);
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
                  height: MediaQuery.of(context).size.height * 0.60,

                  width: MediaQuery.of(context).size.width,
                  // color: Colors.amber,
                  child: FutureBuilder<List<SongModel>>(
                    future: getArtistSongs(widget.artisteId),
                    builder:
                        (context, AsyncSnapshot<List<SongModel>> snapshot) {
                      if (snapshot.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasData) {
                        allArtistesSongs = snapshot.data!;
                        return RefreshIndicator(
                          onRefresh: () => getArtistSongs(widget.artisteId),
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Slidable(
                                startActionPane: ActionPane(
                                    motion: const StretchMotion(),
                                    children: [
                                      SlidableAction(
                                          onPressed: ((context) {
                                            print("hey");
                                          }),
                                          icon: Icons.playlist_add),
                                    ]),
                                endActionPane: ActionPane(
                                    motion: const StretchMotion(),
                                    children: [
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
                                    playMedia(context, allArtistesSongs, index);
                                  },
                                  trailing: Consumer<SongProvider>(
                                    builder: (context, song, child) =>
                                        IconButton(
                                            icon: Icon(index ==
                                                    Provider.of<SongProvider>(
                                                            context,
                                                            listen: false)
                                                        .index
                                                ? Icons.play_arrow
                                                : null),
                                            color: Colors.pinkAccent,
                                            onPressed: () {
                                              // add to favorites
                                            }),
                                  ),
                                  title: Text(snapshot.data![index].title,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis)),
                                  subtitle: Text(
                                    snapshot.data![index].album!,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  leading: QueryArtworkWidget(
                                      artworkBorder: BorderRadius.circular(0),
                                      id: snapshot.data![index].id,
                                      type: ArtworkType.AUDIO),
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
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      persistentFooterButtons: const [PlayingBar()],
    );
  }
}
