import 'package:on_audio_query/on_audio_query.dart';

List<SongModel> queue = [];
List<SongModel> allSongs = [];
List<ArtistModel> allArtistes = [];
List<AlbumModel> allAlbums = [];
List<GenreModel> allGenres = [];
List<PlaylistModel> allPlaylists = [];
List<DeviceModel> allDevices = [];
List<ArtistModel> allArtistesSongs = [];
List<AlbumModel> allAlbumsSongs = [];
List<GenreModel> allGenresSongs = [];
List<PlaylistModel> allPlaylistsSongs = [];
List<DeviceModel> allDevicesSongs = [];

bool isPlaying = false;
SongModel? curTrack;
int curIndex = 0;
ArtistModel? curArtist;
AlbumModel? curAlbum;
GenreModel? curGenre;
PlaylistModel? curPlaylist;
