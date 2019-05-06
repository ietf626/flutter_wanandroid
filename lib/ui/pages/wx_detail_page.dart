import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/api/api.dart';
import 'package:flutter_wanandroid/base/base_list_view.dart';
import 'package:flutter_wanandroid/base/base_model.dart';
import 'package:flutter_wanandroid/model/wx_bean.dart';
import 'package:flutter_wanandroid/model/wx_detail_bean.dart';
import 'package:flutter_wanandroid/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';

import 'wx_search_page.dart';

class WxModel extends BaseModel {
  String id;
  WxModel({this.id});
  Future<DataBean> fetchData({int page = 1, String keyWords = ""}) async {
    var url;
    if (keyWords == null || keyWords.isEmpty) {
      url = sprintf(Api.wx_detail_list, [id, page]);
    } else {
      url = sprintf(Api.wx_search, [id, page, keyWords]);
    }
    print("url:" + url);
    final response = await getClient().get(url);
    return compute(parseData, response.body);
  }
}

DataBean parseData(dynamic str) {
  final parsed = json.decode(str)['data'];
  return DataBean.fromJson(parsed);
}

class WxDetailPage extends StatelessWidget {
  WxBean bean;
  WxModel model;
  WxDetailPage(WxBean data) {
    bean = data;
    model = WxModel(id: bean.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: model.fetchData(),
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
                widget = WxList(
                  data: snapshot.data,
                  model: model,
                );
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => WxSearchPage(
                                    id: bean.id.toString(),
                                  )));
                    })
              ],
            ),
            body: widget,
          );
        });
  }
}

class WxList extends BaseList {
  WxList({this.model, this.data, this.keyWords});
  DataBean data;
  WxModel model;
  String keyWords;
  @override
  BaseListViewState<StatefulWidget, Object> initState() {
    return WxListState(data.datas, model: model, keyWords: keyWords);
  }
}

class WxListState extends BaseListViewState<BaseList, WxDetailBean> {
  WxListState(List<WxDetailBean> list, {this.model, this.keyWords}) {
    data = list;
  }
  WxModel model;
  String keyWords;
  @override
  bool get enableLoadMore => true;

  @override
  Widget buildItem(WxDetailBean item) {
    return Card(
        color: Colors.white,
        child: InkWell(
            onTap: onPressed,
            child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  "作者：${item.author}",
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  "发布时间：${DateFormat("y-M-d h:mm").format(DateTime.fromMillisecondsSinceEpoch(item.publishTime))}",
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ))),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Image(
                          image: AssetImage(Utils.getImgPath('icon_heart_no')),
                          fit: BoxFit.fill,
                          width: 20,
                          height: 20,
                        ))
                  ],
                ))));
  }

  onPressed() {}
  @override
  onLoadMore(int page) {
    model.fetchData(page: currPage, keyWords: keyWords).then((it) {
      final list = it.datas;
      setLoadMoreComplete(list);
    }).catchError(() {
      setLoadMoreError();
    });
  }

  @override
  Future<void> onRefresh() {
    return model.fetchData(keyWords: keyWords).then((it) {
      final list = it.datas;
      refreshData(list, page: it.curPage);
    });
  }
}
