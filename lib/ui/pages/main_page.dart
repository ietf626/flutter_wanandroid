import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/res/strings.dart';

import 'home_page.dart';
import 'hot_page.dart';
import 'new_page.dart';
import 'project_page.dart';
import 'wx_page.dart';

List<String> _pages = Strings.values.keys.toList();

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _pages.length,
        child: Scaffold(
          appBar: AppBar(
            title: TabLayout(),
          ),
          body: TabViewLayout(),
        ));
  }
}

class TabLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new TabBar(
        isScrollable: false,
        indicatorSize: TabBarIndicatorSize.label,
        labelPadding: EdgeInsets.all(12),
        tabs: _pages
            .map((str) => new Tab(text: Strings.getTabValue(str)))
            .toList());
  }
}

class TabViewLayout extends StatelessWidget {
  Widget buildTabView(BuildContext context, String key) {
    switch (key) {
      case Strings.tab_new:
        return NewPage(label: key);
        break;
      case Strings.tab_hot:
        return HotPage(
          label: key,
        );
        break;
      case Strings.tab_project:
        return ProjectPage(
          label: key,
        );
        break;
      case Strings.tab_home:
        return HomePage(
          label: key,
        );
        break;
      case Strings.tab_wx:
        return WxPage(
          label: key,
        );
        break;
      default:
        return Container();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
        children: _pages.map((key) => buildTabView(context, key)).toList());
  }
}
