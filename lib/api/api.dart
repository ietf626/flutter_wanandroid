class Api {
  static final base_url = "https://wanandroid.com/";
  static final String wx_list = "${base_url}wxarticle/chapters/json";
  static final String wx_detail_list = "${base_url}wxarticle/list/%s/%d/json";
  static final String wx_search = "${base_url}wxarticle/list/%s/%s/json?k=%s";
  static final String projects = "${base_url}article/listproject/%d/json";
  static final String image_place_holder =
      "http://iph.href.lu/200x200?text=Loading...";
}
