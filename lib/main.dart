import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/pages/main_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light().copyWith(
          primaryColor: Colors.black,
          accentColor: Colors.black,
          indicatorColor: Colors.white),
      home: MainPage(),
    );
  }
}
