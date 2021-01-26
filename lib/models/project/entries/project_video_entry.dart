import 'project_entry.dart';
import 'package:flutter/material.dart';

class ProjectVideoEntry extends ProjectEntry {
  final String videoUrl;

  ProjectVideoEntry({
    String id,
    String title,
    List<String> tags,
    DateTime creationDate,
    String author,
    this.videoUrl,
  }) : super(id, title, tags, creationDate, author);

  @override
  Widget get displayWidget {
    return Text('hier kommt ein Video hin');
  }

  @override
  Map<String, dynamic> toJson() => {
        '_id': id,
        'entryType': 'VIDEO',
        'title': title,
        'tags': tags,
        'content': videoUrl,
        'creationDate': creationDate.toUtc().toIso8601String()
      };
}
