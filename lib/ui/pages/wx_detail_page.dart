import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/api/api.dart';
import 'package:flutter_wanandroid/base/base_list_view.dart';
import 'package:flutter_wanandroid/base/base_model.dart';
import 'package:flutter_wanandroid/bean/wx_bean.dart';
import 'package:flutter_wanandroid/bean/wx_detail_bean.dart';
import 'package:flutter_wanandroid/utils/utils.dart';
import 'package:intl/intl.dart';
import 'wx_search_page.dart';
import 'package:flutter_wanandroid/model/wx_article_model.dart';
import 'package:flutter_wanandroid/ui/widgets/wx_article_list.dart';
class WxDetailPage extends StatelessWidget {
  WxBean bean;
  WxArticleodel model;
  WxDetailPage(WxBean data) {
    bean = data;
    model = WxArticleodel(id: bean.id.toString());
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
                widget = WxArticleList(
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

