import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/bean/wx_bean.dart';
import 'package:flutter_wanandroid/model/wx_model.dart';
import 'package:flutter_wanandroid/base/base_grid_view.dart';
import 'package:flutter_wanandroid/ui/pages/wx_detail_page.dart';
class WxList extends BaseGridList {
  WxList({this.data,this.model});
  List<WxBean> data;
  WxModel model;
  @override
  BaseGridListViewState<StatefulWidget, Object> initState() {
    return WxListState(data,model);
  }
}

class WxListState extends BaseGridListViewState<WxList,WxBean> {
  WxListState(List<WxBean> list,WxModel model){
    data = list;
    this.model = model;
  }
  WxModel model;

  _onPressd(BuildContext context, WxBean bean) {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => WxDetailPage(bean)));
  }

  @override
  Widget buildItem(WxBean item) {
    return Card(
        color: Colors.white,
        child: InkWell(
            onTap: () {
              _onPressd(context,item);
            },
            child: Center(
                child: Text(
                  item.name,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ))));
  }

  @override
  Future<void> onRefresh() {
    return model.fetchData().then((list) {
      refreshData(list);
    });
  }
}