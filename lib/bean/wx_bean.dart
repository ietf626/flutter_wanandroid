class WxBean {
  List children;
  int courseId;
  int id;
  String name;
  int order;
  int parentChapterId;
  bool userControlSetTop;
  int visible;

  WxBean(
      {this.children,
      this.courseId,
      this.id,
      this.name,
      this.order,
      this.parentChapterId,
      this.userControlSetTop,
      this.visible});

  factory WxBean.fromJson(Map<String, Object> map) {
    return WxBean(
        children: map['children'] as List,
        courseId: map['courseId'] as int,
        id: map['id'] as int,
        name: map['name'] as String,
        order: map['order'] as int,
        parentChapterId: map['parentChapterId'] as int,
        userControlSetTop: map['userControlSetTop'] as bool,
        visible: map['visible'] as int);
  }
}
