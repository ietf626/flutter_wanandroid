import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/api/api.dart';
import 'package:flutter_wanandroid/bean/wx_bean.dart';
import 'package:http/http.dart';
import 'wx_detail_page.dart';
import 'package:flutter_wanandroid/base/base_model.dart';
import 'package:flutter_wanandroid/base/base_list_view.dart';
import 'package:flutter_wanandroid/model/wx_model.dart';
import 'package:flutter_wanandroid/base/base_grid_view.dart';
import 'package:flutter_wanandroid/model/wx_model.dart';
import 'package:flutter_wanandroid/ui/widgets/wx_list.dart';

class WxPage extends StatelessWidget {
  WxPage({Key key, this.label}) : super(key: key);
  String label;
  WxModel model = WxModel();

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
                widget = WxList(data: snapshot.data, model: model);
              }
              break;
          }
          return widget;
        });
    }
}
