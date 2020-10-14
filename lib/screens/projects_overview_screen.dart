import 'package:doku_maker/widgets/main_drawer.dart';
import 'package:doku_maker/widgets/projects_grid.dart';
import 'package:flutter/material.dart';

class ProjectsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Projects'),
      ),
      drawer: MainDrawer(),
      body: ProjectsGrid(),
    );
  }
}
