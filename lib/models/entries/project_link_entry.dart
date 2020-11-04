import 'package:doku_maker/models/entries/project_entry.dart';
import 'package:doku_maker/models/project_tag.dart';
import 'package:flutter/material.dart';

class ProjectLinkEntry extends ProjectEntry {
  final String id;
  final String title;
  final List<ProjectTag> tags;
  final DateTime creationDate;

  final String link;

  const ProjectLinkEntry(
      {this.id, this.title, this.tags, this.creationDate, this.link})
      : super(id, title, tags, creationDate);

  @override
  Widget get displayWidget {
    return Text('Hier kommt ein Link Entry hin');
  }
}
