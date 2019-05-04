class Strings {
  static const String tab_home = "tab_home";
  static const String tab_project = "tab_project";
  static const String tab_hot = "tab_hot";
  static const String tab_new = "tab_new";
  static const String tab_wx = "tab_wx";
  static const String wx_detail = "wx_detail";
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
  };
  static String get(String id) {
    return strs[id];
  }
}
