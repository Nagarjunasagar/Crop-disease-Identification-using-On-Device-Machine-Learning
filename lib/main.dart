import 'package:croheal/constants.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

import 'home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: nBGcolor,
        brightness: Brightness.light,
        primaryColor: nPrimarycolor,
        shadowColor: Colors.grey,
      ),
      home: const HomePage(),
    );
  }
}
