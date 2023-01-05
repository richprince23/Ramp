import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ramp/api/audio_query.dart';
import 'package:ramp/custom.dart';
import 'package:ramp/screens/all_albums.dart';
import 'package:ramp/screens/all_songs.dart';
import 'package:ramp/styles/style.dart';
import 'package:ramp/vars.dart';
import 'package:ramp/widgets/searchbar.dart';

import 'all_artistes.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> with TickerProviderStateMixin {
  // final TextEditingController _search = TextEditingController();

  late final TabController _tabController =
      TabController(vsync: this, length: myTabs.length);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAcess();
    setState(() {
      allSongs = onAudioQuery.querySongs(
        ignoreCase: true,
        orderType: OrderType.ASC_OR_SMALLER,
        sortType: null,
        uriType: Platform.isAndroid ? UriType.EXTERNAL : UriType.INTERNAL,
      ) as List<SongModel>;
      allArtistes = onAudioQuery.queryArtists(
        ignoreCase: true,
        orderType: OrderType.ASC_OR_SMALLER,
        sortType: ArtistSortType.ARTIST,
        uriType: Platform.isAndroid ? UriType.EXTERNAL : UriType.INTERNAL,
      ) as List<ArtistModel>;
      allAlbums = onAudioQuery.queryAlbums(
        ignoreCase: true,
        orderType: OrderType.ASC_OR_SMALLER,
        sortType: null,
        uriType: Platform.isAndroid ? UriType.EXTERNAL : UriType.INTERNAL,
      ) as List<AlbumModel>;
      allGenres = onAudioQuery.queryGenres(
        ignoreCase: true,
        orderType: OrderType.ASC_OR_SMALLER,
        sortType: GenreSortType.GENRE,
        uriType: Platform.isAndroid ? UriType.EXTERNAL : UriType.INTERNAL,
      ) as List<GenreModel>;
      allPlaylists = onAudioQuery.queryPlaylists(
        ignoreCase: true,
        orderType: OrderType.ASC_OR_SMALLER,
        sortType: PlaylistSortType.DATE_ADDED,
        uriType: Platform.isAndroid ? UriType.EXTERNAL : UriType.INTERNAL,
      ) as List<PlaylistModel>;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
            tabs: myTabs,
            controller: _tabController,
            indicatorColor: Colors.pinkAccent),
        // toolbarHeight: MediaQuery.of(context).size.height * 0.15,
        backgroundColor: Colors.transparent,
        elevation: 1,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text("Library",
                style: TextStyle(
                  color: Colors.white70,
                )),
            const SizedBox(
              height: 10,
            ),
            // SearchBar(
            //   controller: _search,
            //   height: MediaQuery.of(context).size.height * 0.05,
            // )
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: MediaQuery.of(context).size.height * 0.1,
              color: darkTheme.colorScheme.surface,
              child: TextButton(
                onPressed: () {},
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.playlist_add,
                        color: Colors.white,
                      ),
                      Text(
                        "New Playlist",
                        style: TextStyle(color: Colors.white),
                      )
                    ]),
              ),
            ),
            Expanded(
              child: Center(
                child: Text("No Playlists added"),
              ),
            ),
          ],
        ),
        AllSongsScreen(),
        AllArtistes(),
        AllAlbums()
      ]),
    );
  }
}
