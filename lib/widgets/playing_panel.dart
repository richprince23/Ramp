import 'dart:math';

import 'package:animations/animations.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:ramp/api/audio_player.dart';
import 'package:ramp/styles/style.dart';
import 'package:rxdart/rxdart.dart' as Rxx;
import '../controllers/songController.dart';
import '../screens/queue_screen.dart';

class NowPlayingPanel extends StatefulWidget {
  // SongModel? track;

  const NowPlayingPanel({
    Key? key,
  }) : super(key: key);

  @override
  State<NowPlayingPanel> createState() => _NowPlayingPanelState();
}

class _NowPlayingPanelState extends State<NowPlayingPanel>
    with TickerProviderStateMixin {
  songController trackController = Get.put<songController>(songController());
  double? value = 0.0;
  late AnimationController animator;
  // late Stream<DurationState> _durationState;
  Icon loopIcon = Icon(Icons.loop);

  Stream<DurationState> get durationStateStream =>
      Rxx.CombineLatestStream.combine2<Duration, Duration?, DurationState>(
          songPlayer.positionStream,
          songPlayer.durationStream,
          (position, duration) => DurationState(
              position: position, total: duration ?? Duration.zero));

  @override
  void initState() {
    // TODO: implement initState
    animator =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    isPlaying == true ? animator.repeat() : animator.stop();

    super.initState();
  }

  @override
  void dispose() {
    animator.dispose();
    // songPlayer.dispose(); // to be removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
        transitionType: ContainerTransitionType.fade,
        closedBuilder: (context, data) {
          return Container(
            height: MediaQuery.of(context).size.height / 12,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(20),
              color: darkTheme.colorScheme.onSecondary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        child: isPlaying == true
                            ? GetBuilder<songController>(builder: (imageData) {
                                return QueryArtworkWidget(
                                    id: imageData.curTrack!.id,
                                    type: ArtworkType.AUDIO);
                              })
                            : CircleAvatar(),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                          child: GetBuilder<songController>(builder: (data) {
                        return Text(
                          isPlaying == true ? data.song : "Not Playing",
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                          softWrap: false,
                        );
                      })),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          trackController.song != ""
                              // ? loadPlay(trackController.curTrack!)
                              ? loadPlay(trackController.curIndex)
                              : () {};
                        },
                        icon: isPlaying == true
                            ? Icon(Icons.pause)
                            : Icon(Icons.play_arrow)),
                    IconButton(
                        onPressed: () {
                          if (songPlayer.hasNext) {
                            trackController
                                .setSong(queue[trackController.curIndex]);
                            loadPlay(trackController.curIndex);
                            songPlayer.seekToNext();
                          }
                        },
                        icon: Icon(Icons.skip_next_rounded)),
                  ],
                ),
              ],
            ),
            // ),
          );
        },
        openBuilder: (context, data) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Now Playing"),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.more_vert_rounded))
              ],
            ),
            body: Stack(alignment: AlignmentDirectional.topCenter, children: [
              Positioned(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                    color: darkTheme.colorScheme.surface,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: animator.view,
                        builder: ((context, child) {
                          return Transform.rotate(
                            angle: animator.value * 2 * pi,
                            child: child,
                          );
                        }),
                        child: GetBuilder<songController>(
                          builder: (controller) {
                            return QueryArtworkWidget(
                                artworkWidth:
                                    MediaQuery.of(context).size.width * 0.4,
                                artworkHeight:
                                    MediaQuery.of(context).size.width * 0.4,
                                id: isPlaying == true
                                    ? controller.curTrack!.id
                                    : 0,
                                artworkBorder: BorderRadius.circular(100),
                                type: ArtworkType.AUDIO);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  color: darkTheme.colorScheme.surface,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GetBuilder<songController>(
                        builder: (controller) {
                          return Text(
                            // widget.track!.title,
                            isPlaying == true
                                ? controller.curTrack!.title
                                : "Not Playing",
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                      GetBuilder<songController>(
                        builder: ((controller) {
                          return Text(
                            isPlaying == true
                                ? controller.curTrack!.artist!
                                : ". . .",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          );
                        }),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: MediaQuery.of(context).size.width,
                        child: StreamBuilder<DurationState>(
                            stream: durationStateStream,
                            builder: ((context, snapshot) {
                              final durationState = snapshot.data;
                              final progress =
                                  durationState?.position ?? Duration.zero;
                              final buffered =
                                  durationState?.buffered ?? Duration.zero;
                              final total =
                                  durationState?.total ?? Duration.zero;

                              final processingState =
                                  songPlayer.processingState;
                              final playing = songPlayer.playing;

                              if (processingState ==
                                  ProcessingState.completed) {
                                animator.stop();
                              }
                              return ProgressBar(
                                // style
                                progressBarColor: Colors.purpleAccent,
                                thumbColor: Colors.purpleAccent,
                                baseBarColor: Colors.purple,
                                barCapShape: BarCapShape.square,
                                progress: progress,
                                buffered: buffered,
                                total: total,
                                onSeek: (duration) {
                                  songPlayer.seek(duration);
                                },
                                onDragUpdate: (details) {
                                  // debugPrint(
                                  // '${details.timeStamp}, ${details.localPosition}');
                                  // songPlayer.seek(details.timeStamp);
                                },
                              );
                            })),
                      ),
                      // play button
                      Container(
                        // margin: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MediaControl(
                                mIcon: Icons.skip_previous,
                                Tap: () {
                                  if (songPlayer.hasPrevious) {
                                    trackController.setSong(
                                        queue[trackController.curIndex--]);
                                    loadPlay(trackController.curIndex);
                                    songPlayer.seekToPrevious();
                                  }
                                }),
                            // oldPlay(),
                            Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50)),
                                child: StreamBuilder<PlayerState>(
                                  stream: songPlayer.playerStateStream,
                                  builder: (context, snapshot) {
                                    final playerState = snapshot.data;
                                    final processingState =
                                        playerState?.processingState;
                                    final playing = playerState?.playing;
                                    if (processingState ==
                                            ProcessingState.loading ||
                                        processingState ==
                                            ProcessingState.buffering) {
                                      return Container(
                                        margin: const EdgeInsets.all(8.0),
                                        width: 32.0,
                                        height: 32.0,
                                        child:
                                            const CircularProgressIndicator(),
                                      );
                                    } else if (playing != true) {
                                      return trackController.song != ""
                                          ? IconButton(
                                              icon: const Icon(
                                                Icons.play_arrow,
                                                color: Colors.black,
                                                size: 50,
                                              ),
                                              onPressed: () {
                                                songPlayer.play();
                                                setState(() {
                                                  isPlaying = true;
                                                  animator.repeat();
                                                });
                                              })
                                          : IconButton(
                                              icon: const Icon(
                                                Icons.stop,
                                                color: Colors.grey,
                                                size: 50,
                                              ),
                                              onPressed: () {});
                                    } else if (processingState !=
                                        ProcessingState.completed) {
                                      return IconButton(
                                          icon: const Icon(
                                            Icons.pause,
                                            color: Colors.black,
                                            size: 50,
                                          ),
                                          onPressed: () {
                                            songPlayer.pause();
                                            setState(() {
                                              isPlaying = false;
                                              animator.stop();
                                            });
                                          });
                                    } else {
                                      animator.stop();
                                      return IconButton(
                                        icon: const Icon(Icons.play_arrow,
                                            color: Colors.black),
                                        iconSize: 50.0,
                                        onPressed: () =>
                                            songPlayer.seek(Duration.zero),
                                      );
                                    }
                                  },
                                )),

                            MediaControl(
                                mIcon: Icons.skip_next,
                                Tap: () {
                                  if (songPlayer.hasNext) {
                                    trackController.setSong(
                                        queue[trackController.curIndex]);
                                    loadPlay(trackController.curIndex);
                                    songPlayer.seekToNext();
                                  }
                                  // songPlayer.play();
                                }),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                songPlayer.loopModeStream.listen((event) {
                                  if (songPlayer.loopMode == LoopMode.off) {
                                    songPlayer.setLoopMode(LoopMode.one);
                                    setState(() {
                                      loopIcon = Icon(Icons.repeat_one);
                                    });
                                  } else if (songPlayer.loopMode ==
                                      LoopMode.one) {
                                    songPlayer.setLoopMode(LoopMode.all);
                                    setState(() {
                                      loopIcon = Icon(Icons.repeat_on);
                                    });
                                  } else if (songPlayer.loopMode ==
                                      LoopMode.all) {
                                    songPlayer.setLoopMode(LoopMode.off);
                                    setState(() {
                                      loopIcon = Icon(Icons.loop);
                                    });
                                  }
                                });
                                setState(() {
                                  loopIcon = Icon(Icons.repeat_one);
                                });
                                //
                              },
                              icon: loopIcon,
                              color: Colors.grey,
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.shuffle,
                                  color: Colors.grey,
                                )),
                            IconButton(
                                onPressed: () {
                                  Get.to(() => QueueScreen());
                                },
                                icon: Icon(
                                  Icons.playlist_play,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ]),
          );
        });
  }
}

class MediaControl extends StatefulWidget {
  IconData mIcon; //media control icon

  Function() Tap;

  MediaControl({Key? key, required this.mIcon, required this.Tap})
      : super(key: key);

  @override
  State<MediaControl> createState() => _MediaControlState();
}

class _MediaControlState extends State<MediaControl> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(50)),
      child: IconButton(
        onPressed: widget.Tap,
        icon: Icon(
          widget.mIcon,
          color: Colors.black,
          size: 30,
        ),
      ),
    );
  }
}

class DurationState {
  const DurationState(
      {this.position = Duration.zero,
      this.buffered,
      this.total = Duration.zero});
  final Duration position;
  final Duration? buffered;
  final Duration total;
}
