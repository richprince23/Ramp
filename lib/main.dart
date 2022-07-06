import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramp/screens/library.dart';
import 'package:ramp/screens/main_screen.dart';
// import 'get/get.dart';

void main() {
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
