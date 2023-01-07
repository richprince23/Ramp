import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:ramp/api/audio_query.dart';
import 'package:ramp/controllers/song_provider.dart';
import 'package:ramp/screens/playing_bar.dart';
import 'package:ramp/vars.dart';

import '../styles/style.dart';
import 'package:ramp/custom.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

int curPage = 0;

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    requestPermission();
    // getMedia();
    updateSong();
  }

  requestPermission() async {
    // Web platform don't support permissions methods.
    if (!kIsWeb) {
      bool permissionStatus = await onAudioQuery.permissionsStatus();
      if (!permissionStatus) {
        await onAudioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }

  void updateSong() {
    // setState(() {
    songPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        if (curQueue.isNotEmpty) {
          // curTrack = curQueue[index];
          curIndex = index;
          Provider.of<SongProvider>(context, listen: false)
              .setSong(curQueue[index]);
          Provider.of<SongProvider>(context, listen: false).setIndex(index);
        }
      }
    });
    // });
  }

  @override
  void dispose() {
    songPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        kPages[curPage],
      ]
          // flex: 1,
          ),
      bottomNavigationBar: NavigationBar(
          elevation: 0,
          selectedIndex: curPage,
          height: MediaQuery.of(context).size.height * 0.08,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          onDestinationSelected: (int id) {
            setState(() {
              curPage = id;
            });
          },
          backgroundColor: darkTheme.colorScheme.surface,
          destinations: [
            IconButton(
              onPressed: () {
                setState(() {
                  curPage = 0;
                });
              },
              icon: curPage == 0
                  ? const Icon(Icons.home, color: Colors.purpleAccent)
                  : const Icon(Icons.home_outlined),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  curPage = 1;
                });
              },
              icon: curPage == 1
                  ? const Icon(Icons.search, color: Colors.purpleAccent)
                  : const Icon(Icons.search_outlined),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  curPage = 2;
                });
              },
              icon: curPage == 2
                  ? const Icon(Icons.local_fire_department,
                      color: Colors.orange)
                  : const Icon(Icons.local_fire_department_outlined),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  curPage = 3;
                });
              },
              icon: curPage == 3
                  ? const Icon(Icons.person, color: Colors.purpleAccent)
                  : const Icon(Icons.person_outlined),
            ),
          ]),
      // bottomSheet: NowPlayingPanel(
      //     // track: curTrack,
      //     ),
      // persistentFooterButtons: [NowPlayingPanel()],
      persistentFooterButtons: [
        PlayingBar(),
      ],
    );
  }
}
