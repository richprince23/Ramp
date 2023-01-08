import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:ramp/api/audio_player.dart';
import 'package:ramp/controllers/song_provider.dart';
import 'package:ramp/screens/playing_bar.dart';
import 'package:ramp/vars.dart';

class AlbumScreen extends StatefulWidget {
  // final ArtistModel artistModel;

  final int albumId;
  late String? albumName;
  // AlbumScreen({Key? key, required this.artistModel, })
  AlbumScreen({Key? key, required this.albumId, this.albumName})
      : super(key: key);

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  String? albumName;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.albumName ?? "Untitled"),
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
                    id: widget.albumId,
                    type: ArtworkType.ALBUM,
                    artworkBorder: BorderRadius.circular(10)),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
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
                        onPressed: () {
                          print(allAlbumsSongs);
                        },
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
                      const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
                  height: MediaQuery.of(context).size.height * 0.6,

                  width: MediaQuery.of(context).size.width,
                  // color: Colors.amber,
                  child: FutureBuilder<List<SongModel>>(
                    future: getAlbumSongs(widget.albumId),
                    initialData: allAlbumsSongs,
                    builder:
                        (context, AsyncSnapshot<List<SongModel>> snapshot) {
                      if (snapshot.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasData) {
                        allArtistesSongs = snapshot.data!;
                        return RefreshIndicator(
                          onRefresh: () => getAlbumSongs(widget.albumId),
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
                                  title: Text(
                                      snapshot.data![index].displayNameWOExt,
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
