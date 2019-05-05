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

final Client client = Client();

Future<List<WxDetailBean>> fetchData({int page = 1}) async {
  var url = sprintf(Api.wx_detail_list, [bean.id, page]);
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => WxSearchPage()));
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

  ScrollController _controller = ScrollController();
  int _currPage = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
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
    return fetchData().then((list) {
      setState(() {
        data = list;
      });
    });
  }

  _getMore() {
    if (_isLoading) return;
    _isLoading = true;
    _currPage++;
    fetchData(page: _currPage).then((list) {
      setState(() {
        data.addAll(list);
        _isLoading = false;
      });
    }).catchError(() {
      ToastUtil.show(Strings.get(Strings.fetch_data_error));
      _isLoading = false;
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
