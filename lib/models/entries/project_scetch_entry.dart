import 'package:doku_maker/models/entries/project_entry.dart';
import 'package:doku_maker/models/project_tag.dart';
import 'package:flutter/material.dart';

class ProjectScetchEntry extends ProjectEntry {
  final String id;
  final String title;
  final List<ProjectTag> tags;
  final DateTime creationDate;

  final String todo;

  const ProjectScetchEntry(
      {this.id, this.title, this.tags, this.creationDate, this.todo})
      : super(id, title, tags, creationDate);

  @override
  Widget get displayWidget {
    return Text('Hier kommt eine Skizze hin');
  }
}
