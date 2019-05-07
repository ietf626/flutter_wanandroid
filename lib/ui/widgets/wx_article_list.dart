import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/base/base_list_view.dart';
import 'package:flutter_wanandroid/bean/wx_detail_bean.dart';
import 'package:flutter_wanandroid/model/wx_article_model.dart';
import 'package:flutter_wanandroid/res/strings.dart';
import 'package:flutter_wanandroid/utils/utils.dart';
import 'package:intl/intl.dart';

class WxArticleList extends BaseList {
  WxArticleList({this.model, this.data, this.keyWords});
  DataBean data;
  WxArticleodel model;
  String keyWords;
  @override
  BaseListViewState<StatefulWidget, Object> initState() {
    return WxArticleListState(data.datas, model: model, keyWords: keyWords);
  }
}

class WxArticleListState extends BaseListViewState<BaseList, WxDetailBean> {
  WxArticleListState(List<WxDetailBean> list, {this.model, this.keyWords}) {
    data = list;
  }
  WxArticleodel model;
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
                                  "${Strings.get(Strings.author) + item.author}",
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  "${Strings.get(Strings.publish_time) + DateFormat("y-M-d h:mm").format(DateTime.fromMillisecondsSinceEpoch(item.publishTime))}",
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
