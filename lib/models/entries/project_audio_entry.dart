import 'package:doku_maker/models/entries/project_entry.dart';
import 'package:flutter/material.dart';

class ProjectAudioEntry extends ProjectEntry {
  final String audioUrl;

  const ProjectAudioEntry({
    String id,
    String title,
    List<String> tags,
    DateTime creationDate,
    this.audioUrl,
  }) : super(id, title, tags, creationDate);

  @override
  Widget get displayWidget {
    return Text('Hier kommt ein Audio Entry hin');
  }

  @override
  Map<String, dynamic> toJson() => {
        '_id': id,
        'entryType': 'AUDIO',
        'title': title,
        'tags': tags,
        'content': audioUrl,
        'creationDate': creationDate.toUtc().toIso8601String()
      };
}
