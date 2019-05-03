import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, this.label}) : super(key: key);
  String label;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Text(label);
  }
}
