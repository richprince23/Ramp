import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ramp/screens/all_artistes.dart';

import 'api/audio_query.dart';
import 'screens/all_songs.dart';
import 'screens/library.dart';

// class MyConsts {
List<Widget> kPages = [
  Library(),
  Center(child: Text("Search")),
  Center(child: Text("Discover")),
  Center(child: Text("Profile")),
];
// }

getAcess() async {
  if (!kIsWeb) {
    bool status = await onAudioQuery.permissionsStatus();
    if (!status) {
      await onAudioQuery.permissionsRequest();
    }
    // setState(() {});
  }
}
