import 'package:flutter/material.dart';
import 'package:ramp/custom.dart';
import 'package:ramp/screens/all_albums.dart';
import 'package:ramp/screens/all_songs.dart';
import 'package:ramp/styles/style.dart';
import 'package:ramp/vars.dart';

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
    getAcess();
    super.initState();
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
                onPressed: () {
                  for (var song in allSongs) {
                    print(song.title);
                  }
                },
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
        AllAlbumScreen()
      ]),
    );
  }
}
