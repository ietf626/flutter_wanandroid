import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/api/api.dart';
import 'package:flutter_demo/model/wx_bean.dart';
import 'package:http/http.dart';

final Client client = Client();

Future<List<WxBean>> fetchData() async {
  final response = await client.get(Api.wx_list);
  return compute(parseData, response.body);
}

List<WxBean> parseData(String str) {
  final parsed = json.decode(str)['data'].cast<Map<String, dynamic>>();
  return parsed.map<WxBean>((json) => WxBean.fromJson(json)).toList();
}

class WxPage extends StatelessWidget {
  WxPage({Key key, this.label}) : super(key: key);
  String label;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Error:${snapshot.error}'));
              } else {
                return WxList(data: snapshot.data);
              }
              break;
          }
        });
  }
}

class WxList extends StatefulWidget {
  WxList({this.data});
  List<WxBean> data;
  @override
  State<StatefulWidget> createState() {
    return WxListState(data: data);
  }
}

class WxListState extends State<WxList> {
  WxListState({this.data});
  List<WxBean> data;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: data.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          return Card(
              color: Colors.white,
              child: InkWell(
                  onTap: _onPressd,
                  child: Center(
                      child: Text(
                    data[index].name,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ))));
        });
  }

  _onPressd() {}
  Future<void> _onRefresh() {
    return fetchData().then((list) {
      setState(() {
        data = list;
      });
    });
  }
}
