import 'package:doku_maker/models/entries/project_entry.dart';
import 'package:flutter/material.dart';

class ProjectVideoEntry extends ProjectEntry {
  final String videoUrl;

  const ProjectVideoEntry({
    String id,
    String title,
    List<String> tags,
    DateTime creationDate,
    this.videoUrl,
  }) : super(id, title, tags, creationDate);

  @override
  Widget get displayWidget {
    return Text('hier kommt ein Video hin');
  }

  @override
  Map<String, dynamic> toJson() => {
        '_id': id,
        'type': 'VIDEO',
        'title': title,
        'tags': tags,
        'content': videoUrl,
        'creationDate': creationDate.toIso8601String()
      };
}
