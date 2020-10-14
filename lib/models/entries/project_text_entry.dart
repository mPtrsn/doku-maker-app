import 'package:doku_maker/models/entries/project_entry.dart';
import 'package:doku_maker/models/project_tag.dart';
import 'package:flutter/material.dart';

class ProjectTextEntry extends ProjectEntry {
  final int id;
  final String title;
  final List<ProjectTag> tags;

  final String text;

  const ProjectTextEntry({this.id, this.title, this.tags, this.text})
      : super(id, title, tags);

  @override
  Widget get displayWidget {
    return Text(this.text);
  }
}
