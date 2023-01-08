import 'dart:io';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import "package:provider/provider.dart";
import 'package:ramp/api/audio_query.dart';
import 'package:ramp/vars.dart';

getMedia() async {
  await getSongs();
  await getArtistes();
  await getAlbums();
  await getGenres();
  await getPlaylists();
}

Future<List<ArtistModel>> getArtistes() async {
  return allArtistes = await onAudioQuery.queryArtists(
    ignoreCase: true,
    orderType: OrderType.ASC_OR_SMALLER,
    sortType: ArtistSortType.ARTIST,
    uriType: Platform.isAndroid ? UriType.EXTERNAL : UriType.INTERNAL,
  );
}

Future<List<AlbumModel>> getAlbums() async {
  return allAlbums = await onAudioQuery.queryAlbums(
    ignoreCase: true,
    orderType: OrderType.DESC_OR_GREATER,
    sortType: null,
    uriType: Platform.isAndroid ? UriType.EXTERNAL : UriType.INTERNAL,
  );
}

Future<List<GenreModel>> getGenres() async {
  return allGenres = await onAudioQuery.queryGenres(
    ignoreCase: true,
    orderType: OrderType.DESC_OR_GREATER,
    sortType: GenreSortType.GENRE,
    uriType: Platform.isAndroid ? UriType.EXTERNAL : UriType.INTERNAL,
  );
}

Future<List<PlaylistModel>> getPlaylists() async {
  return allPlaylists = await onAudioQuery.queryPlaylists(
    ignoreCase: true,
    orderType: OrderType.DESC_OR_GREATER,
    sortType: PlaylistSortType.DATE_ADDED,
    uriType: Platform.isAndroid ? UriType.EXTERNAL : UriType.INTERNAL,
  );
}

Future<List<SongModel>> getSongs() async {
  allSongs = await onAudioQuery.querySongs(
    ignoreCase: true,
    orderType: OrderType.ASC_OR_SMALLER,
    sortType: SongSortType.ARTIST,
    uriType: Platform.isAndroid ? UriType.EXTERNAL : UriType.INTERNAL,
  );
  return allSongs;
}

Future<List<ArtistModel>> getArtists() async {
  allArtistes = await onAudioQuery.queryArtists(
    ignoreCase: true,
    orderType: OrderType.ASC_OR_SMALLER,
    sortType: ArtistSortType.ARTIST,
    uriType: Platform.isAndroid ? UriType.EXTERNAL : UriType.INTERNAL,
  );
  return allArtistes;
}

Future<List<SongModel>> getArtistSongs(int id) async {
  return allArtistesSongs = await onAudioQuery.queryAudiosFrom(
      AudiosFromType.ARTIST_ID, id,
      sortType: SongSortType.ALBUM);
}

Future<List<SongModel>> getAlbumSongs(int id) async {
  return allAlbumsSongs = await onAudioQuery.queryAudiosFrom(
      AudiosFromType.ALBUM_ID, id,
      sortType: SongSortType.ALBUM);
}

class SongProvider extends ChangeNotifier {
  void setSong(SongModel song) {
    curTrack = song;
    notifyListeners();
  }

  SongModel? getSong() => curTrack;

  void setIndex(int index) {
    curIndex = index;
    notifyListeners();
  }

  void setPlaying(bool state) {
    isPlaying = state;
    notifyListeners();
  }

  get playing => songPlayer.playing;

  get index => curIndex;

}
