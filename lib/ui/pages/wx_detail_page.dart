import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/api/api.dart';
import 'package:flutter_wanandroid/model/wx_bean.dart';
import 'package:flutter_wanandroid/model/wx_detail_bean.dart';
import 'package:flutter_wanandroid/utils/utils.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
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

WxBean bean;
int currPage = 1;

class WxDetailPage extends StatelessWidget {
  WxDetailPage(WxBean data) {
    bean = data;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchData(bean.id.toString()),
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
                widget = WxDetailList(data: snapshot.data);
              }
              break;
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(bean.name),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      //todo
                    })
              ],
            ),
            body: widget,
          );
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
          final temp = data[index];
          return Card(
              color: Colors.white,
              child: InkWell(
                  onTap: _onPressd,
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              child: Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        temp.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        "作者：${temp.author}",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        "发布时间：${DateFormat("y-M-d h:mm").format(DateTime.fromMillisecondsSinceEpoch(temp.publishTime))}",
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  ))),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Image(
                                image: AssetImage(
                                    Utils.getImgPath('icon_heart_no')),
                                fit: BoxFit.fill,
                                width: 20,
                                height: 20,
                              ))
                        ],
                      ))));
        });
  }

  _onPressd() {}
  Future<void> _onRefresh() {
    return fetchData(bean.id.toString()).then((list) {
      setState(() {
        data = list;
      });
    });
  }
}
