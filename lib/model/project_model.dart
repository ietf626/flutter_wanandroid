import 'package:flutter_wanandroid/base/base_model.dart';
import 'package:sprintf/sprintf.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter_wanandroid/bean/project_bean.dart';
import 'package:flutter_wanandroid/api/api.dart';
import 'package:flutter_wanandroid/utils/log_utils.dart';
class ProjectModel extends BaseModel{
  Future<ProjectBean> fetchData({int page = 0}) async{
    final url = sprintf(Api.projects,[page]);
    LogUtils.log("url:"+url);
    final response = await getClient().get(url);
    return compute(parseData, response.body);
  }
}
ProjectBean parseData(dynamic str){
 return ProjectBean.fromJson(json.decode(str));
}