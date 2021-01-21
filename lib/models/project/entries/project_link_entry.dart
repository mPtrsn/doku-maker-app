import 'project_entry.dart';
import 'package:flutter/material.dart';

class ProjectLinkEntry extends ProjectEntry {
  final String link;

  const ProjectLinkEntry({
    String id,
    String title,
    List<String> tags,
    DateTime creationDate,
    this.link,
  }) : super(id, title, tags, creationDate);

  @override
  Widget get displayWidget {
    return Text('Hier ist ein Link: $link');
  }

  @override
  Map<String, dynamic> toJson() => {
        '_id': id,
        'entryType': 'LINK',
        'title': title,
        'tags': tags,
        'content': link,
        'creationDate': creationDate.toUtc().toIso8601String()
      };
}
