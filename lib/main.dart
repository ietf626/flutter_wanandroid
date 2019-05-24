import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/ui/pages/main_page.dart';

import 'config/constants.dart';
import 'ui/pages/wx_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        Constants.ROUTE_PAGE_MAIN: (ctx) => MainPage(),
        Constants.ROUTE_PAGE_WX: (ctx) => WxPage(),
      },
      title: 'Flutter Wanandroid',
      theme: ThemeData.light().copyWith(
          primaryColor: Colors.black,
          accentColor: Colors.black,
          indicatorColor: Colors.white),
      home: MainPage(),
    );
  }
}
