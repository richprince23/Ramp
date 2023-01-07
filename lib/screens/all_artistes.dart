import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:ramp/controllers/song_provider.dart';
import 'package:ramp/custom.dart';
import 'package:ramp/screens/artist_screen.dart';
import 'package:ramp/vars.dart';

class AllArtistes extends StatefulWidget {
  const AllArtistes({Key? key}) : super(key: key);

  @override
  State<AllArtistes> createState() => _AllArtistesState();
}

class _AllArtistesState extends State<AllArtistes> {
  @override
  void initState() {
    // TODO: implement initState
    // getArtists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getArtistes(allArtistes);
  }

  RefreshIndicator getArtistes(List<ArtistModel> snapshot) {
    return RefreshIndicator(
      onRefresh: () async => setState(
        () {
          getArtists();
        },
      ),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 40),
        itemCount: snapshot.length,
        cacheExtent: 200 ,
        itemBuilder: ((context, index) {
          if (snapshot.isEmpty) {
            return const Center(
              child: Text("No Artistes found"),
            );
          }
          return ListTile(
            onTap: () {
              Get.to(
                  preventDuplicates: true,
                  () => ArtistScreen(
                      artisteId: snapshot[index].id,
                      artistName: snapshot[index].artist),
                  transition: Transition.rightToLeft);
            },
            title: Text(snapshot[index].artist,
                style: const TextStyle(color: Colors.white)),
            subtitle: Text(snapshot[index].numberOfTracks.toString()),
            leading: QueryArtworkWidget(
                id: snapshot[index].id, type: ArtworkType.ARTIST),
          );
        }),
      ),
    );
  }
}
