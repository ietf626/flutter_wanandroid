import 'package:sprintf/sprintf.dart';
import 'package:flutter_wanandroid/base/base_model.dart';
import 'package:flutter_wanandroid/api/api.dart';
import 'package:flutter_wanandroid/bean/wx_detail_bean.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter_wanandroid/utils/log_utils.dart';
class WxArticleodel extends BaseModel {
  String id;
  WxArticleodel({this.id});
  Future<DataBean> fetchData({int page = 1, String keyWords = ""}) async {
    var url;
    if (keyWords == null || keyWords.isEmpty) {
      url = sprintf(Api.wx_detail_list, [id, page]);
    } else {
      url = sprintf(Api.wx_search, [id, page, keyWords]);
    }
    LogUtils.log("url:" + url);
    final response = await getClient().get(url);
    return compute(parseData, response.body);
  }
}
DataBean parseData(dynamic str) {
  final parsed = json.decode(str)['data'];
  return DataBean.fromJson(parsed);
}
