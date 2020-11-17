import 'package:doku_maker/provider/projects_provider.dart';
import 'package:doku_maker/widgets/entry_element.dart';
import 'package:doku_maker/widgets/project_detail_entry_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  static const String routeName = '/project-detail';

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
      body: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: <Widget>[
            Container(
                height: constraints.maxHeight * 0.12,
                child: ProjectDetailEntryButtons(project: project)),
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
                    height: constraints.maxHeight * 0.85,
                    child: ListView.builder(
                      itemBuilder: (ctx, idx) => EntryElement(
                        entry: project.entries[idx],
                        projectId: project.id,
                      ),
                      itemCount: project.entries.length,
                    ),
                  )
          ],
        );
      }),
    );
  }
}
