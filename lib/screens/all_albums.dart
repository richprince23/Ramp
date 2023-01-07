import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:ramp/screens/album_screen.dart';
import 'package:ramp/screens/main_screen.dart';
import 'package:ramp/styles/style.dart';
import 'package:ramp/vars.dart';

import '../api/audio_query.dart';

class AllAlbumScreen extends StatefulWidget {
  const AllAlbumScreen({Key? key}) : super(key: key);

  @override
  State<AllAlbumScreen> createState() => _AllAlbumScreenState();
}

class _AllAlbumScreenState extends State<AllAlbumScreen> {
  @override
  Widget build(BuildContext context) {
    return buildAlbums(allAlbums);
  }
}

GridView buildAlbums(List<AlbumModel> snapshot) {
  return GridView.builder(
    gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    padding: const EdgeInsets.only(bottom: 40),
    itemCount: snapshot.length,
    itemBuilder: ((context, index) {
      return Card(
        color: Colors.transparent,
        elevation: 0,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
          onTap: () {
            Get.to(() => AlbumScreen(
                  albumId: snapshot[index].id,
                  albumName: snapshot[index].album,
                ));
          },
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  // color: Colors.white,
                  height: MediaQuery.of(context).size.width / 2.6,
                  width: MediaQuery.of(context).size.width / 2.6,
                  // width: 80,
                  child: QueryArtworkWidget(
                      artworkFit: BoxFit.fill,
                      artworkBorder: BorderRadius.circular(8),
                      id: snapshot[index].id,
                      type: ArtworkType.ALBUM),
                ),
                Text(
                  snapshot[index].album,
                  style: const TextStyle(
                      overflow: TextOverflow.ellipsis, fontSize: 12),
                ),
              ]),
        ),
      );
    }),
  );
}
