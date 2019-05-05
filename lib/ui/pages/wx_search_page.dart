import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/res/strings.dart';
import 'package:flutter/rendering.dart';

class WxSearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WxSearchPageState();
  }
}

class WxSearchPageState extends State<WxSearchPage> {
  TextEditingController controller = TextEditingController();
  bool isEmpty = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Expanded(
              child: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                labelText: Strings.get(Strings.wx_search),
                labelStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none),
            autofocus: false,
            cursorColor: Colors.white,
            controller: controller,
            textInputAction: TextInputAction.search,
            onSubmitted: (value) => {},
            onChanged: (value) {
              setState(() {
                isEmpty = value.trim().isEmpty;
              });
            },
          )),
          Align(alignment: Alignment.centerRight, child: _buildClearButton())
        ]),
      ),
    );
  }

  Widget _buildClearButton() {
    if (isEmpty) {
      return null;
    } else {
      return IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () {
            controller.clear();
            setState(() {
              isEmpty = true;
            });
          });
    }
  }
}


