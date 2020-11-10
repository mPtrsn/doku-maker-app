import 'package:doku_maker/models/project.dart';
import 'package:doku_maker/screens/project_detail_screen.dart';
import 'package:flutter/material.dart';

class ProjectsGridElement extends StatelessWidget {
  final Project project;

  const ProjectsGridElement(this.project);

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
            project.imageUrl,
            headers: {'Authorization': 'Basic cmVhZGVyOnJlYWRlcg=='},
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black45,
          leading: IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {},
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            project.title,
          ),
        ),
      ),
    );
  }
}
