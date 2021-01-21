import 'package:doku_maker/provider/projects_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'projects_grid_element.dart';

class ProjectsGrid extends StatelessWidget {
  Future<void> _getAllProjects(BuildContext context) async {
    await Provider.of<ProjectsProvider>(context, listen: false)
        .getAllProjects();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getAllProjects(context),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () => _getAllProjects(context),
                  child: Consumer<ProjectsProvider>(
                    builder: (context, value, child) => Container(
                      margin: const EdgeInsets.all(10),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (ctx, idx) =>
                            ProjectsGridElement(value.projects[idx]),
                        itemCount: value.projects.length,
                      ),
                    ),
                  ),
                ),
    );
  }
}
