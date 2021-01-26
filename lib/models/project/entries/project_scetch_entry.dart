import 'project_entry.dart';
import 'package:flutter/material.dart';

class ProjectScetchEntry extends ProjectEntry {
  final String todo;

  ProjectScetchEntry({
    String id,
    String title,
    List<String> tags,
    DateTime creationDate,
    this.todo,
  }) : super(id, title, tags, creationDate);

  @override
  Widget get displayWidget {
    return Text('Hier kommt eine Skizze hin');
  }

  @override
  Map<String, dynamic> toJson() => {
        '_id': id,
        'entryType': 'SCETCH',
        'title': title,
        'tags': tags,
        'content': todo,
        'creationDate': creationDate.toUtc().toIso8601String()
      };
}
