import 'package:doku_maker/models/project/project.dart';
import 'package:doku_maker/provider/auth_provider.dart';
import 'package:doku_maker/screens/project/project_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config.dart';

class ProjectsGridElement extends StatelessWidget {
  final Project project;

  const ProjectsGridElement(this.project);

  Widget createIcon(BuildContext ctx) {
    var userId = Provider.of<AuthProvider>(ctx).userId;

    if (project.owners.contains(userId)) {
      return IconButton(
        icon: Icon(Icons.person),
        onPressed: () {},
        color: Theme.of(ctx).accentColor,
      );
    } else {
      return IconButton(
        icon: Icon(Icons.group),
        onPressed: () {},
        color: Theme.of(ctx).accentColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProjectDetailScreen.routeName,
                arguments: project.id);
          },
          child: Image.network(
            Config.couchdbURL + project.imageUrl,
            headers: {'Authorization': 'Basic cmVhZGVyOnJlYWRlcg=='},
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black45,
          leading: createIcon(context),
          title: Text(
            project.title,
          ),
        ),
      ),
    );
  }
}
