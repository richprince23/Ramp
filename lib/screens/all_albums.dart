import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:ramp/screens/main_screen.dart';
import 'package:ramp/styles/style.dart';

import '../api/audio_query.dart';

class AllAlbums extends StatefulWidget {
  const AllAlbums({Key? key}) : super(key: key);

  @override
  State<AllAlbums> createState() => _AllAlbumsState();
}

class _AllAlbumsState extends State<AllAlbums> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AlbumModel>>(
      future: onAudioQuery.queryAlbums(
        ignoreCase: true,
        orderType: OrderType.DESC_OR_GREATER,
        sortType: null,
        uriType: Platform.isAndroid ? UriType.EXTERNAL : UriType.INTERNAL,
      ),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              padding: const EdgeInsets.only(bottom: 40),
              itemCount: snapshot.data!.length,
              itemBuilder: ((context, index) {
                return Card(
                  color: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: InkWell(
                    onTap: () {
                      // Get.to(() => MainScreen(),);
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
                                artworkBorder: BorderRadius.circular(0),
                                id: snapshot.data![index].id,
                                type: ArtworkType.ALBUM),
                          ),
                          Text(
                            snapshot.data![index].album,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis, fontSize: 12),
                          ),
                        ]),
                  ),
                );
                // ListTile(
                //   title: Text(snapshot.data![index].album,
                //       style: const TextStyle(color: Colors.white)),
                //   subtitle: Text(snapshot.data![index].artist ?? "Unknown"),
                //   leading: QueryArtworkWidget(
                //       artworkBorder: BorderRadius.circular(0),
                //       id: snapshot.data![index].id,
                //       type: ArtworkType.ALBUM),
                // );
              }));
        } else {
          return const Center(
            child: Text("No songs found"),
          );
        }
      },
    );
  }
}
