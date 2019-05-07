import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_wanandroid/api/api.dart';
import 'package:flutter_wanandroid/bean/wx_bean.dart';
import 'package:flutter_wanandroid/base/base_model.dart';
class WxModel extends BaseModel {
  Future<List<WxBean>> fetchData() async {
    final response = await getClient().get(Api.wx_list);
    return compute(parseData, response.body);
  }
}
List<WxBean> parseData(dynamic str) {
  final parsed = json.decode(str)['data'].cast<Map<String, dynamic>>();
  return parsed.map<WxBean>((json) => WxBean.fromJson(json)).toList();
}
