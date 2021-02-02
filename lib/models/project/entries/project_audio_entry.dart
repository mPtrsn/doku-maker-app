import 'package:flutter/material.dart';

import 'project_entry.dart';

class ProjectAudioEntry extends ProjectEntry {
  final String audioUrl;

  ProjectAudioEntry({
    String id,
    String title,
    List<String> tags,
    DateTime creationDate,
    String author,
    this.audioUrl,
  }) : super(id, title, tags, creationDate, author);

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
        'creationDate': creationDate.toUtc().toIso8601String(),
        'author': author,
      };
}
