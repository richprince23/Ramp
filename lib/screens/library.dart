import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ramp/api/audio_query.dart';
import 'package:ramp/screens/all_albums.dart';
import 'package:ramp/screens/all_songs.dart';
import 'package:ramp/styles/style.dart';
import 'package:ramp/widgets/searchbar.dart';

import 'all_artistes.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> with TickerProviderStateMixin {
  final TextEditingController _search = TextEditingController();

  late final TabController _tabController =
      TabController(vsync: this, length: myTabs.length);

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
      body: TabBarView(controller: _tabController, children: const [
        Center(
          child: Text("No Playlists added"),
        ),
        AllSongsScreen(),
        AllArtistes(),
        AllAlbums()
      ]),
    );
  }
}
