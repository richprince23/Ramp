import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:ramp/api/audio_query.dart';
import 'package:ramp/screens/main_screen.dart';
// import 'get/get.dart';

void main() async {
  await OnAudioQuery();
  await OnAudioRoom().initRoom();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ramp',
      theme: ThemeData.dark().copyWith(
          useMaterial3: true,
          primaryColor: Colors.pink,
          primaryColorDark: Colors.purple,
          primaryColorLight: Colors.amber),
      home: MainScreen(),
      // home: Get.to(),
    );
  }
}
