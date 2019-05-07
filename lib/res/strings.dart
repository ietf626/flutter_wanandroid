class Strings {
  static const String tab_home = "tab_home";
  static const String tab_project = "tab_project";
  static const String tab_hot = "tab_hot";
  static const String tab_new = "tab_new";
  static const String tab_wx = "tab_wx";
  static const String wx_detail = "wx_detail";
  static const String wx_search = "wx_search";
  static const String load_more = "load_more";
  static const String fetch_data_error = "fetch_data_error";
  static const String fetch_data_end = "fetch_data_end";
  static const String author = "author";
  static const String publish_time = "publish_time";
  static const String publish_time1 = "publish_time1";
  static const Map<String, String> values = {
    Strings.tab_home: "主页",
    Strings.tab_project: "项目",
    Strings.tab_hot: "热门",
    Strings.tab_wx: "公众号",
    Strings.tab_new: "动态"
  };

  static String getTabValue(String id) {
    return values[id];
  }

  static const Map<String, String> strs = {
    Strings.wx_detail: "公众号历史文章",
    Strings.wx_search: "请输入关键词",
    Strings.load_more: "加载更多...",
    Strings.fetch_data_error: "获取数据失败~~o(>_<)o ~~",
    Strings.fetch_data_end: "没有更多数据了。",
    Strings.author: "作者：",
    Strings.publish_time: "发布时间：",
    Strings.publish_time1: "时间：",
  };

  static String get(String id) {
    return strs[id];
  }
}
