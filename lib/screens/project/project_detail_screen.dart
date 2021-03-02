import 'package:doku_maker/models/project/project.dart';
import 'package:doku_maker/provider/projects_provider.dart';
import 'package:doku_maker/screens/project/project_settings_screen.dart';
import 'package:doku_maker/widgets/project/entry_element.dart';
import 'package:doku_maker/widgets/project/project_detail_entry_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectDetailScreen extends StatelessWidget {
  static const String routeName = '/project-detail';

  @override
  Widget build(BuildContext context) {
    ProjectsProvider projectProvider = Provider.of<ProjectsProvider>(context);
    String id = ModalRoute.of(context).settings.arguments as String;
    Project project = projectProvider.findById(id);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(project.title),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: GestureDetector(
              child: Icon(Icons.settings),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ProjectSettingsScreen.routeName,
                  arguments: project,
                );
              },
            ),
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: <Widget>[
            Container(
                //height: constraints.maxHeight * 0.12,
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
                : Expanded(
                    child: Container(
                      height: constraints.maxHeight * 0.85,
                      child: ListView.builder(
                        itemBuilder: (ctx, idx) => EntryElement(
                          entry: project.entries[idx],
                          projectId: project.id,
                        ),
                        itemCount: project.entries.length,
                      ),
                    ),
                  )
          ],
        );
      }),
    );
  }
}
