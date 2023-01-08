import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:ramp/controllers/song_provider.dart';
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
    // getArtists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildArtistes();
  }

  FutureBuilder<List<ArtistModel>> buildArtistes() {
    return FutureBuilder<List<ArtistModel>>(
      future: getArtistes(),
      initialData: allArtistes,
      builder:
          (BuildContext context, AsyncSnapshot<List<ArtistModel>> snapshot) {
        return RefreshIndicator(
          onRefresh: () async => setState(
            () {
              getArtists();
            },
          ),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 40),
            itemCount: snapshot.data!.length,
            cacheExtent: 200,
            itemBuilder: ((context, index) {
              if (snapshot.data == null) {
                return const Center(
                  child: Text("No Artistes found"),
                );
              }
              return ListTile(
                onTap: () {
                  Get.to(
                      preventDuplicates: true,
                      () => ArtistScreen(
                            artisteId: snapshot.data![index].id,
                            artistName: snapshot.data![index].artist == null
                                ? "Unknown Artiste"
                                : snapshot.data![index].artist.toString(),
                          ),
                      transition: Transition.rightToLeft);
                },
                title: Text(
                    snapshot.data![index].artist == null
                        ? "Unknown Artiste"
                        : snapshot.data![index].artist,
                    style: const TextStyle(color: Colors.white)),
                subtitle: Text(snapshot.data![index].numberOfTracks.toString()),
                leading: QueryArtworkWidget(
                    id: snapshot.data![index].id, type: ArtworkType.ARTIST),
              );
            }),
          ),
        );
      },
    );
  }
}
