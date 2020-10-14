import 'package:doku_maker/screens/new_text_entry_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    Project project = ModalRoute.of(context).settings.arguments as Project;
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Name'),
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
                      context: context, builder: (ctx) => NewTextEntryModal());
                }),
                _buildEntryButton(context, Icons.image, () {}),
                _buildEntryButton(context, Icons.play_arrow, () {}),
                _buildEntryButton(context, Icons.mic, () {}),
                _buildEntryButton(context, Icons.gesture, () {}),
                _buildEntryButton(context, Icons.link, () {}),
              ],
            ),
          ),
          Container(
            height: 300,
            child: ListView.builder(
              itemBuilder: (ctx, idx) => ExpansionTile(
                title: Text(project.entries[idx].title),
                children: [project.entries[idx].displayWidget],
              ),
              itemCount: project.entries.length,
            ),
          )
        ],
      ),
    );
  }
}
