import 'package:doku_maker/screens/project/new_project_screen.dart';
import 'package:doku_maker/widgets/main_drawer.dart';
import 'package:doku_maker/widgets/project/projects_grid.dart';
import 'package:flutter/material.dart';

class ProjectsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Projects'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(NewProjectScreen.routeName),
          )
        ],
      ),
      drawer: MainDrawer(),
      body: ProjectsGrid(),
    );
  }
}
