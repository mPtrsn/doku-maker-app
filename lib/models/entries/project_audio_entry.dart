import 'package:doku_maker/models/entries/project_entry.dart';
import 'package:doku_maker/models/project_tag.dart';
import 'package:flutter/material.dart';

class ProjectAudioEntry extends ProjectEntry {
  final String id;
  final String title;
  final List<ProjectTag> tags;
  final DateTime creationDate;

  final String audioUrl;

  const ProjectAudioEntry(
      {this.id, this.title, this.tags, this.creationDate, this.audioUrl})
      : super(id, title, tags, creationDate);

  @override
  Widget get displayWidget {
    return Text('Hier kommt ein Audio Entry hin');
  }
}
