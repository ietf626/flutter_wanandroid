import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/api/api.dart';
import 'package:flutter_wanandroid/base/base_list_view.dart';
import 'package:flutter_wanandroid/bean/project_bean.dart';
import 'package:flutter_wanandroid/model/project_model.dart';
import 'package:flutter_wanandroid/utils/utils.dart';

class ProjectList extends BaseList {
  ProjectModel model;
  ProjectBean bean;

  ProjectList(ProjectModel model, ProjectBean bean) {
    this.model = model;
    this.bean = bean;
  }

  @override
  BaseListViewState<StatefulWidget, Object> initState() {
    return ProjectListState(model, bean.data.datas);
  }
}

class ProjectListState extends BaseListViewState<ProjectList, DataListBean> {
  @override
  bool enableLoadMore = true;
  ProjectModel model;

  ProjectListState(ProjectModel model, List<DataListBean> data) {
    this.model = model;
    this.data = data;
  }

  @override
  Widget buildItem(DataListBean item) {
    return Card(
        margin: EdgeInsets.fromLTRB(8, 10, 8, 0),
        color: Colors.white,
        child: Container(
            padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                  child: FadeInImage.assetNetwork(
                    placeholder: Utils.getImgPath("icon_image_place_holder"),
                    image: item.envelopePic,
                    fit: BoxFit.cover,
                    width: 80,
                    height: 80,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                Expanded(
                  child: Container(
                      height: 80,
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            item.title,
                            maxLines: 1,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Text(
                                item.desc,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black.withAlpha(200)),
                              )),
                        ],
                      )),
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Image(
                      image: AssetImage(Utils.getImgPath('icon_heart_no')),
                      fit: BoxFit.fill,
                      width: 20,
                      height: 20,
                    ))
              ],
            )));
  }

  @override
  Future<void> onRefresh() {
    return model.fetchData().then((bean) {
      refreshData(bean.data.datas);
    });
  }

  @override
  onLoadMore(int page) {
    model.fetchData(page: page).then((bean) {
      setLoadMoreComplete(bean.data.datas);
    }).catchError(setLoadMoreError());
  }
}
