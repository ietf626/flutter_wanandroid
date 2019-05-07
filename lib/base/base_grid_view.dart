import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/res/strings.dart';
import 'package:flutter_wanandroid/utils/toast_util.dart';

abstract class BaseGridList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return initState();
  }

  BaseGridListViewState initState();
}

abstract class BaseGridListViewState<T extends StatefulWidget, R extends Object>
    extends State<T> {
  List<R> data = List();
  int currPage = 1;
  ScrollController _controller = ScrollController();
  bool isLoading = false;
  bool enableLoadMore = false;
  int crossAxisCount = 3;
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        if (enableLoadMore) _onLoadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: onRefresh,
        child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: _getItemCount(),
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            controller: _controller,
            itemBuilder: (context, index) {
              if (index >= data.length) {
                return buildGetMoreWidget();
              }
              final temp = data[index];
              return buildItem(temp);
            }));
  }

  _getItemCount() {
    if (enableLoadMore)
      return data.length + 1;
    else
      return data.length;
  }

  refreshData(List<R> list, {int page = 1}) {
    setState(() {
      currPage = page;
      data = list;
    });
  }

  setLoadMoreComplete(List<R> list) {
    setState(() {
      if (list.isEmpty) {
        currPage--;
        ToastUtil.show(Strings.get(Strings.fetch_data_end));
      } else {
        data.addAll(list);
      }
      isLoading = false;
    });
  }

  setLoadMoreError() {
    ToastUtil.show(Strings.get(Strings.fetch_data_error));
    isLoading = false;
  }

  _onLoadMore() {
    if (isLoading) return;
    isLoading = true;
    currPage++;
    onLoadMore(currPage);
  }

  onLoadMore(int page) {}
  Future<void> onRefresh();
  Widget buildItem(R item);
  Widget buildGetMoreWidget() {
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
