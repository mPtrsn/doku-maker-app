import 'package:doku_maker/provider/projects_provider.dart';
import 'package:doku_maker/screens/new_image_entry_modal.dart';
import 'package:doku_maker/screens/new_text_entry_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  static const String routeName = '/project-detail';

  Widget _buildEntryButton(BuildContext ctx, IconData icon, Function onTab) {
    return Ink(
      decoration: ShapeDecoration(
        shape: CircleBorder(),
        color: Theme.of(ctx).accentColor,
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onTab,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments as String;
    Project project = Provider.of<ProjectsProvider>(context).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(project.title),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: GestureDetector(
              child: Icon(Icons.settings),
              onTap: () {},
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 80,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildEntryButton(context, Icons.title, () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) => NewTextEntryModal(project.id));
                }),
                _buildEntryButton(context, Icons.image, () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) => NewImageEntryModal(project.id));
                }),
                _buildEntryButton(context, Icons.play_arrow, () {}),
                _buildEntryButton(context, Icons.mic, () {}),
                _buildEntryButton(context, Icons.gesture, () {}),
                _buildEntryButton(context, Icons.link, () {}),
              ],
            ),
          ),
          Divider(
            thickness: 3,
          ),
          (project.entries == null || project.entries.isEmpty)
              ? Container(
                  child: Text(
                    'No Entries',
                    style: TextStyle(fontSize: 26),
                  ),
                )
              : Container(
                  height: 300,
                  child: ListView.builder(
                    itemBuilder: (ctx, idx) {
                      return ExpansionTile(
                        title: Text(
                            '${project.entries[idx].title}  -  ${project.entries[idx].creationDate}'),
                        children: [project.entries[idx].displayWidget],
                      );
                    },
                    itemCount: project.entries.length,
                  ),
                )
        ],
      ),
    );
  }
}
