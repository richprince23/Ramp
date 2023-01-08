import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:ramp/controllers/song_provider.dart';
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
    return buildAlbums();
  }
}

Widget buildAlbums() {
  return FutureBuilder<List<AlbumModel>>(
    future: getAlbums(),
    initialData: allAlbums,
    builder: ((context, AsyncSnapshot<List<AlbumModel>> snapshot) =>
        RefreshIndicator(
          onRefresh: () => getAlbums(),
          child: GridView.builder(
            cacheExtent: 1000,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            padding: const EdgeInsets.only(bottom: 40),
            itemCount: snapshot.data!.length,
            itemBuilder: ((context, index) {
              if (snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("No Albums Found"),
                );
              }
              if (snapshot.data!.isNotEmpty)
                return Card(
                  color: Colors.transparent,
                  elevation: 0,
                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: InkWell(
                    onTap: () {
                      Get.to(() => AlbumScreen(
                            albumId: snapshot.data![index].id,
                            albumName:
                                snapshot.data![index].album.toString() == ""
                                    ? "Unknown Album"
                                    : snapshot.data![index].album.toString(),
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
                                id: snapshot.data![index].id,
                                type: ArtworkType.ALBUM),
                          ),
                          Text(
                            snapshot.data![index].album == null
                                ? "Unknown Album"
                                : snapshot.data![index].album.toString(),
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis, fontSize: 12),
                          ),
                        ]),
                  ),
                );
              else {
                return Center(
                  child: Text("No Albums"),
                );
              }
            }),
          ),
        )),
  );
}
