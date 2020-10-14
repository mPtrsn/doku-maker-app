import 'package:doku_maker/models/entries/project_entry.dart';
import 'package:doku_maker/models/project_tag.dart';
import 'package:flutter/material.dart';

class ProjectImageEntry extends ProjectEntry {
  final int id;
  final String title;
  final List<ProjectTag> tags;

  final String imageUrl;

  const ProjectImageEntry({this.id, this.title, this.tags, this.imageUrl})
      : super(id, title, tags);

  @override
  Widget get displayWidget {
    return Image.network(
      this.imageUrl,
      fit: BoxFit.cover,
    );
  }
}
