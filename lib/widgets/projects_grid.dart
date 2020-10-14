import 'package:flutter/material.dart';

import '../models/project.dart';
import '../widgets/projects_grid_element.dart';

import '../dummy_data.dart';

class ProjectsGrid extends StatelessWidget {
  final List<Project> projects = DUMMY_DATA;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, idx) => ProjectsGridElement(projects[idx]),
        itemCount: projects.length,
      ),
    );
  }
}
