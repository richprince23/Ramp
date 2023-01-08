import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ramp/screens/main_screen.dart';
import 'package:ramp/controllers/song_provider.dart';
// import 'get/get.dart';

void main() async {
  // OnAudioQuery();
  // await OnAudioRoom().initRoom();
  WidgetsFlutterBinding.ensureInitialized();
  // getMedia();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => SongProvider()),
    ],
    child: MyApp(),
  ));
  // const MyApp());
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
