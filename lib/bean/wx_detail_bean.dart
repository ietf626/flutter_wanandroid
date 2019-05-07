
class WxDetailRespBean {
  String errorMsg;
  int errorCode;
  DataBean data;

  WxDetailRespBean({this.errorMsg, this.errorCode, this.data});

  WxDetailRespBean.fromJson(Map<String, dynamic> json) {
    this.errorMsg = json['errorMsg'];
    this.errorCode = json['errorCode'];
    this.data = json['data'] != null ? DataBean.fromJson(json['data']) : null;
  }
}
class DataBean {
  bool over;
  int curPage;
  int offset;
  int pageCount;
  int size;
  int total;
  List<WxDetailBean> datas;

  DataBean(
      {this.over,
        this.curPage,
        this.offset,
        this.pageCount,
        this.size,
        this.total,
        this.datas});

  DataBean.fromJson(Map<String, dynamic> json) {
    this.over = json['over'];
    this.curPage = json['curPage'];
    this.offset = json['offset'];
    this.pageCount = json['pageCount'];
    this.size = json['size'];
    this.total = json['total'];
    this.datas = (json['datas'] as List) != null
        ? (json['datas'] as List).map((i) => WxDetailBean.fromJson(i)).toList()
        : null;
  }
}

class WxDetailBean {
//  apkLink: "",
//  author: "鸿洋",
//  chapterId: 408,
//  chapterName: "鸿洋",
//  collect: false,
//  courseId: 13,
//  desc: "",
//  envelopePic: "",
//  fresh: false,
//  id: 8341,
//  link: "https://mp.weixin.qq.com/s/U7twuqKXo4IDyU4_1MLCEg",
//  niceDate: "2019-04-30",
//  origin: "",
//  prefix: "",
//  projectLink: "",
//  publishTime: 1556553600000,
//  superChapterId: 408,
//  superChapterName: "公众号",
//  tags: [
//  {
//  name: "公众号",
//  url: "/wxarticle/list/408/1"
//  }
//  ],
//  title: "Android 仿微信朋友圈图片拖拽返回",
//  type: 0,
//  userId: -1,
//  visible: 1,
//  zan: 0

  String apkLink;
  String author;
  int chapterId;
  String chapterName;
  bool collect;
  int courseId;
  String desc;
  String envelopePic;
  bool fresh;
  int id;
  String link;
  String niceDate;
  String origin;
  String prefix;
  String projectLink;
  int publishTime;
  int superChapterId;
  String superChapterName;
  List<WxTag> tags;
  String title;
  int type;
  int userId;
  int visible;
  int zan;

  WxDetailBean(
      {this.apkLink,
      this.author,
      this.chapterId,
      this.chapterName,
      this.collect,
      this.courseId,
      this.desc,
      this.envelopePic,
      this.fresh,
      this.id,
      this.link,
      this.niceDate,
      this.origin,
      this.prefix,
      this.projectLink,
      this.publishTime,
      this.superChapterName,
      this.superChapterId,
      this.tags,
      this.title,
      this.type,
      this.userId,
      this.visible,
      this.zan});
  factory WxDetailBean.fromJson(Map<String, dynamic> map) {
    return WxDetailBean(
      apkLink: map['apkLink'],
      author: map['author'],
      chapterId: map['chapterId'],
      chapterName: map[''],
      collect: map['collect'],
      courseId: map['courseId'],
      desc: map['desc'],
      envelopePic: map['envelopePic'],
      fresh: map['fresh'],
      id: map['id'],
      link: map['link'],
      niceDate: map['niceDate'],
      origin: map['origin'],
      prefix: map['prefix'],
      projectLink: map['projectLink'],
      publishTime: map['publishTime'],
      superChapterName: map['superChapterName'],
      superChapterId: map['superChapterId'],
      tags: map['tags']
          .cast<Map<String, dynamic>>()
          .map<WxTag>((json) => WxTag.fromJson(json))
          .toList(),
      title: map['title'],
      type: map['type'],
      userId: map['userId'],
      visible: map['visible'],
      zan: map['zan'],
    );
  }
}

class WxTag {
  String name;
  String url;
  WxTag({this.name, this.url});
  factory WxTag.fromJson(Map<String, Object> map) {
    return WxTag(name: map['name'], url: map['url']);
  }
}
