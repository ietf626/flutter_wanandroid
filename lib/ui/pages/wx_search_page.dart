import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/res/strings.dart';
import 'package:flutter/rendering.dart';
import 'wx_detail_page.dart';

class WxSearchPage extends StatefulWidget {
  WxSearchPage({this.id});
  String id;
  @override
  State<StatefulWidget> createState() {
    return WxSearchPageState(id: id);
  }
}

class WxSearchPageState extends State<WxSearchPage> {
  WxSearchPageState({this.id});
  String id;
  WxDetailModel model;
  TextEditingController controller = TextEditingController();
  bool isEmpty = true;
  String key;
  @override
  void initState() {
    super.initState();
    model = WxDetailModel(id: id);
  }

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
            onSubmitted: (value) {
              setState(() {key = value;});
            },
            onChanged: (value) {
              setState(() {
                isEmpty = value.trim().isEmpty;
              });
            },
          )),
          Align(alignment: Alignment.centerRight, child: buildClearButton())
        ]),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (key==null||key.isEmpty) {
      return null;
    } else {
      return FutureBuilder(
          future: model.fetchData(keyWords: key),
          builder: (context, snapshot) {
            Widget widget;
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                widget = Center(
                  child: CircularProgressIndicator(),
                );
                break;
              default:
                if (snapshot.hasError) {
                  widget = Center(child: Text('Error:${snapshot.error}'));
                } else {
                  widget = WxDetailList(
                    data: snapshot.data,
                    model: model,
                  );
                }
                break;
            }
            return widget;
          });
    }
  }

  Widget buildClearButton() {
    if (isEmpty) {
      return null;
    } else {
      return IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () {
            controller.clear();
            setState(() {
              key = "";
              isEmpty = true;
            });
          });
    }
  }
}
