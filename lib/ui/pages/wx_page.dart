import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/api/api.dart';
import 'package:flutter_wanandroid/model/wx_bean.dart';
import 'package:http/http.dart';

import 'wx_detail_page.dart';

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
                widget = WxList(data: snapshot.data);
              }
              break;
          }
          return widget;
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
                  onTap: () {
                    _onPressd(context, data[index]);
                  },
                  child: Center(
                      child: Text(
                    data[index].name,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ))));
        });
  }

  _onPressd(BuildContext context, WxBean bean) {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => WxDetailPage(bean)));
  }

  Future<void> _onRefresh() {
    return fetchData().then((list) {
      setState(() {
        data = list;
      });
    });
  }
}
