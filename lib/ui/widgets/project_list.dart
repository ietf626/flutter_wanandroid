import 'package:flutter_wanandroid/base/base_list_view.dart';
import 'package:flutter_wanandroid/model/project_model.dart';
import 'package:flutter_wanandroid/bean/project_bean.dart';
import 'package:flutter/material.dart';

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
    return Text(item.desc);
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
