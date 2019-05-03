import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {
  NewPage({Key key, this.label}) : super(key: key);
  String label;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Text(label);
  }
}
