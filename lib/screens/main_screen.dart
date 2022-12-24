import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/songController.dart';
import '../styles/style.dart';
import 'package:ramp/custom.dart';
import '../widgets/playing_panel.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

int curPage = 0;

class _MainScreenState extends State<MainScreen> {
  songController trackController = Get.put<songController>(songController());

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
      persistentFooterButtons: [NowPlayingPanel()],
    );
  }
}
