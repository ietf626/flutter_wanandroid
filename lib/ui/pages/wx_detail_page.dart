import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/api/api.dart';
import 'package:flutter_wanandroid/model/wx_detail_bean.dart';
import 'package:http/http.dart';
import 'package:sprintf/sprintf.dart';

final Client client = Client();

Future<List<WxDetailBean>> fetchData(String id) async {
  var url = sprintf(Api.wx_detail_list, [id, 1]);
  print("url:" + url);
  final response = await client.get(url);
  return compute(parseData, response.body);
}

List<WxDetailBean> parseData(String str) {
  final parsed = json.decode(str)['data'];
  currPage = parsed['curPage'];
  final datas = parsed['datas'].cast<Map<String, dynamic>>();
  return datas
      .map<WxDetailBean>((json) => WxDetailBean.fromJson(json))
      .toList();
}

String id;
int currPage = 1;

class WxDetailPage extends StatelessWidget {
  WxDetailPage(String id_str) {
    id = id_str;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchData(id),
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
                return WxDetailList(data: snapshot.data);
              }
              break;
          }
        });
  }
}

class WxDetailList extends StatefulWidget {
  WxDetailList({this.data});
  List<WxDetailBean> data;
  @override
  State<StatefulWidget> createState() {
    return WxDetailListState(data: data);
  }
}

class WxDetailListState extends State<WxDetailList> {
  WxDetailListState({this.data});
  List<WxDetailBean> data;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
              color: Colors.white,
              child: InkWell(
                  onTap: _onPressd,
                  child: Center(
                      child: Text(
                    data[index].link,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ))));
        });
  }

  _onPressd() {}
  Future<void> _onRefresh() {
    return fetchData(id).then((list) {
      setState(() {
        data = list;
      });
    });
  }
}
