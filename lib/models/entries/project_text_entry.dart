import 'package:doku_maker/models/entries/project_entry.dart';
import 'package:flutter/material.dart';

class ProjectTextEntry extends ProjectEntry {
  final String text;

  const ProjectTextEntry({
    String id,
    String title,
    List<String> tags,
    DateTime creationDate,
    this.text,
  }) : super(id, title, tags, creationDate);

  @override
  Widget get displayWidget {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        this.text,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        '_id': id,
        'type': 'TEXT',
        'title': title,
        'tags': tags,
        'content': text,
        'creationDate': creationDate.toIso8601String()
      };
}
