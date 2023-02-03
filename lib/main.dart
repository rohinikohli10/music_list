import 'package:flutter/material.dart';
import 'package:music_list_app/screen/audio_screen1.dart';
import 'screen/audio_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.purple,
          primarySwatch: Colors.lime),
      darkTheme: ThemeData.dark(),
      home: const AudioUi1(title: 'Flutter Music list'),
    );
  }
}
