import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/ui/widgets/project_list.dart';
import 'package:flutter_wanandroid/model/project_model.dart';
class ProjectPage extends StatelessWidget {
  ProjectPage({Key key, this.label}) : super(key: key);
  String label;
  ProjectModel model = ProjectModel();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: model.fetchData(),
        builder: (context, snapshot) {
          Widget widget;
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              widget = Center(
                child: CircularProgressIndicator(),
              );
              break;
            default:
              if (snapshot.hasError) {
                widget = Center(child: Text('Error:${snapshot.error}'));
              } else {
                widget = ProjectList(model,snapshot.data);
              }
              break;
          }
          return widget;
        });
  }
}



