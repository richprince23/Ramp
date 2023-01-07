import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:ramp/api/audio_query.dart';
import 'package:ramp/controllers/song_provider.dart';
import 'package:ramp/screens/artist_screen.dart';
import 'package:ramp/styles/style.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:ramp/vars.dart';
// import 'package:rxdart/rxdart.dart';

import 'package:rxdart/rxdart.dart' as rxx;

class NowPlayingScreen extends StatefulWidget {
  SongModel? track;

  NowPlayingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen>
    with TickerProviderStateMixin {
  double? value = 0.0;
  late AnimationController animator;
  late Stream<DurationState> _durationState;

  Stream<DurationState> get durationStateStream =>
      rxx.CombineLatestStream.combine2<Duration, Duration?, DurationState>(
          songPlayer.positionStream,
          songPlayer.durationStream,
          (position, duration) => DurationState(
              position: position, total: duration ?? Duration.zero));

  @override
  void initState() {
    // TODO: implement initState
    animator =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    songPlayer.playing == true ? animator.repeat() : animator.stop();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Now Playing"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.more_vert_rounded))
        ],
      ),
      body: Column(mainAxisSize: MainAxisSize.max, children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          child: Consumer<SongProvider>(builder: (context, song, child) {
            int artisteID = song.getSong()!.artistId!;
            return Container(
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
                    child: song.getSong() != null
                        ? QueryArtworkWidget(
                            artworkWidth:
                                MediaQuery.of(context).size.width * 0.3,
                            artworkHeight:
                                MediaQuery.of(context).size.width * 0.3,
                            id: curTrack!.id,
                            artworkBorder: BorderRadius.circular(100),
                            type: ArtworkType.AUDIO)
                        : const CircleAvatar(
                            radius: 80,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          // curTrack != null ? curTrack!.title : "Track 1",
                          context.read<SongProvider>().getSong()!.title ?? "Track 1",
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: () => Get.to(
                            preventDuplicates: true,
                            () => ArtistScreen(
                                artisteId: artisteID,
                                artistName: curTrack!.artist!),
                            transition: Transition.zoom,
                          ),
                          child: Text(
                            curTrack != null
                                ? curTrack!.artist!
                                : "Unknown Artist",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
        ),
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.7,
            // bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              color: darkTheme.colorScheme.surface,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // mainAxisSize: MainAxisSize.max,
                children: [
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
                          final total = durationState?.total ?? Duration.zero;

                          final processingState = songPlayer.processingState;
                          final playing = songPlayer.playing;

                          if (processingState == ProcessingState.completed) {
                            animator.stop();
                          }
                          return ProgressBar(
                            barHeight: 6,
                            thumbRadius: 4,
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
                  Container(
                    margin: EdgeInsets.only(top: 60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MediaControl(
                            mIcon: Icons.skip_previous,
                            Tap: () {
                              if (songPlayer.hasPrevious) {
                                songPlayer.seekToPrevious();
                                songPlayer.play();
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
                                    child: const CircularProgressIndicator(),
                                  );
                                } else if (playing != true) {
                                  return IconButton(
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
                                      });
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
                                songPlayer.seekToNext();
                                songPlayer.play();
                              }
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
                            onPressed: () {},
                            icon: Icon(
                              Icons.loop,
                              color: Colors.grey,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.shuffle,
                              color: Colors.grey,
                            )),
                        IconButton(
                            onPressed: () {},
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
          ),
        ),
      ]),
    );
  }

//old play buttno
  Container oldPlay() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(50)),
      child: IconButton(
        onPressed: () {
          if (songPlayer.playing == true) {
            songPlayer.pause();
            setState(() {
              isPlaying = false;
              animator.stop();
            });
          } else {
            songPlayer.play();
            animator.repeat();
            setState(() {
              isPlaying = true;
            });
          }
        },
        icon: isPlaying == true
            ? const Icon(
                Icons.pause,
                color: Colors.black,
                size: 30,
              )
            : const Icon(
                Icons.play_arrow,
                color: Colors.black,
                size: 30,
              ),
      ),
    );
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
