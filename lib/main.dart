
import 'package:cats_app/pages/SearchPage.dart';
import 'package:cats_app/pages/detail_page.dart';
import 'package:cats_app/pages/direct.page.dart';
import 'package:cats_app/pages/homePage.dart';
import 'package:cats_app/pages/myCat.dart';
import 'package:cats_app/pages/uploadPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DirectPage(),
      routes: {
        HomePage.id: (context) => HomePage(),
        SearchPage.id: (context) => SearchPage(),
        DetailPage.id: (context) => DetailPage(),
        UploadPage.id: (context) => UploadPage(),
        MyCat.id: (context) => MyCat(),
      },
      );
  }
}
