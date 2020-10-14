import 'package:doku_maker/models/entries/project_entry.dart';
import 'package:doku_maker/models/project_tag.dart';
import 'package:flutter/material.dart';

class ProjectAudioEntry extends ProjectEntry {
  final int id;
  final String title;
  final List<ProjectTag> tags;

  final String audioUrl;

  const ProjectAudioEntry({this.id, this.title, this.tags, this.audioUrl})
      : super(id, title, tags);

  @override
  Widget get displayWidget {
    return Text('Hier kommt ein Audio Entry hin');
  }
}
