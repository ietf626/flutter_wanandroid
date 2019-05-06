import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/api/api.dart';
import 'package:flutter_wanandroid/model/wx_bean.dart';
import 'package:flutter_wanandroid/model/wx_detail_bean.dart';
import 'package:flutter_wanandroid/res/strings.dart';
import 'package:flutter_wanandroid/utils/toast_util.dart';
import 'package:flutter_wanandroid/utils/utils.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';

import 'wx_search_page.dart';

class WxDetailModel {
  final Client client = Client();
  String id;
  WxDetailModel({this.id});
  Future<DataBean> fetchData({int page = 1, String keyWords = ""}) async {
    var url;
    if (keyWords==null||keyWords.isEmpty) {
      url = sprintf(Api.wx_detail_list, [id, page]);
    } else {
      url = sprintf(Api.wx_search, [id, page, keyWords]);
    }
    print("url:" + url);
    final response = await client.get(url);
    return parseData(response.body);
//  return compute(parseData, response.body);
  }

  DataBean parseData(String str) {
    final parsed = json.decode(str)['data'];
    return DataBean.fromJson(parsed);
  }
}

class WxDetailPage extends StatelessWidget {
  WxBean bean;
  WxDetailModel model;
  WxDetailPage(WxBean data) {
    bean = data;
    model = WxDetailModel(id: bean.id.toString());
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

class WxDetailList extends StatefulWidget {
  WxDetailList({this.data, this.model, this.keyWords});
  DataBean data;
  WxDetailModel model;
  String keyWords;
  @override
  State<StatefulWidget> createState() {
    return WxDetailListState(bean: data, model: model);
  }
}

class WxDetailListState extends State<WxDetailList> {
  WxDetailListState({this.bean, this.model, this.keyWords});
  DataBean bean;
  List<WxDetailBean> data;
  WxDetailModel model;
  int currPage = 1;
  ScrollController _controller = ScrollController();
  bool isLoading = false;
  String keyWords;
  @override
  void initState() {
    super.initState();
    data = bean.datas;
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _getMore();
      }
    });
  }

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
        itemCount: data.length + 1,
        controller: _controller,
        itemBuilder: (context, index) {
          if (index >= data.length) {
            return _getMoreWidget();
          }
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
    return model.fetchData(keyWords: keyWords).then((it) {
      final list = it.datas;
      currPage = it.curPage;
      setState(() {
        data = list;
      });
    });
  }

  _getMore() {
    if (isLoading) return;
    isLoading = true;
    currPage++;
    model.fetchData(page: currPage, keyWords: keyWords).then((it) {
      final list = it.datas;
      setState(() {
        if (list.isEmpty) {
          currPage--;
          ToastUtil.show(Strings.get(Strings.fetch_data_end));
        } else {
          data.addAll(list);
        }
        isLoading = false;
      });
    }).catchError(() {
      ToastUtil.show(Strings.get(Strings.fetch_data_error));
      isLoading = false;
    });
  }

  _getMoreWidget() {
    return Center(
        child: Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(width: 20, height: 20, child: CircularProgressIndicator()),
          Container(
              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                Strings.get(Strings.load_more),
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              )),
        ],
      ),
    ));
  }
}
