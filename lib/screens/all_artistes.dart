import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:ramp/screens/artist_screen.dart';

import '../api/audio_query.dart';

class AllArtistes extends StatefulWidget {
  const AllArtistes({Key? key}) : super(key: key);

  @override
  State<AllArtistes> createState() => _AllArtistesState();
}

class _AllArtistesState extends State<AllArtistes> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArtistModel>>(
      future: onAudioQuery.queryArtists(
          ignoreCase: true,
          orderType: OrderType.DESC_OR_GREATER,
          sortType: null,
          uriType: UriType.EXTERNAL),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          return ListView.builder(
              padding: const EdgeInsets.only(bottom: 40),
              itemCount: snapshot.data!.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  onTap: () {
                    Get.to(
                        () => ArtistScreen(
                              artistModel: snapshot.data![index],
                            ),
                        transition: Transition.leftToRight);
                  },
                  title: Text(snapshot.data![index].artist,
                      style: const TextStyle(color: Colors.white)),
                  subtitle:
                      Text(snapshot.data![index].numberOfTracks.toString()),
                  leading: QueryArtworkWidget(
                      id: snapshot.data![index].id, type: ArtworkType.ARTIST),
                );
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
