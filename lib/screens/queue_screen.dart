import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:ramp/api/audio_query.dart';
import 'package:ramp/controllers/songController.dart';
import 'package:ramp/vars.dart';
import 'package:ramp/widgets/playing_panel.dart';
import '../api/audio_player.dart';

class QueueScreen extends StatefulWidget {
  const QueueScreen({Key? key}) : super(key: key);

  @override
  State<QueueScreen> createState() => QueueScreenState();
}

class QueueScreenState extends State<QueueScreen> {
  songController trackController = Get.put<songController>(songController());

  Future<List<SongModel>> getQueue() async {
    return queue;
  }

  @override
  void initState() {
    songPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        updateIndex(index);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            // height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButton(),
                TextButton.icon(
                    onPressed: () async {
                      setState(() {
                        queue.clear();
                        getQueue();
                      });
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text("Clear All")),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  getQueue();
                });
              },
              child: Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.transparent,
                  child: FutureBuilder<List<SongModel>>(
                      initialData: queue,
                      future: getQueue(),
                      builder:
                          ((context, AsyncSnapshot<List<SongModel>> snapshot) {
                        if (snapshot.data == null) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasData) {
                          queue.clear();
                          queue = snapshot.data!;

                          return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    setState(() {
                                      isPlaying = songPlayer.playing;
                                      trackController.curIndex = index;
                                    });
                                    Get.find<songController>()
                                        .setSong(snapshot.data![index]);
                                    loadPlay(trackController.curIndex);
                                  },
                                  trailing: IconButton(
                                      icon:
                                          const Icon(Icons.more_horiz_outlined),
                                      onPressed: () {
                                        // add to favorites
                                      }),
                                  title: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          snapshot.data![index].title,
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(snapshot.data![index].artist ??
                                      "Unknown Artiste"),
                                  leading: QueryArtworkWidget(
                                      id: snapshot.data![index].id,
                                      type: ArtworkType.AUDIO),
                                );
                              });
                        } else {
                          return const Center(
                            child: Text("No songs found"),
                          );
                        }
                      }))),
            ),
          ),
        ],
      )),
      persistentFooterButtons: const [NowPlayingPanel()],
    );
  }

  void updateIndex(int index) {
    setState(() {
      if (queue.isNotEmpty) {
        trackController.setSong(queue[index]);
        // curIndex = index;
      }
    });
  }
}
