import 'project_entry.dart';
import 'package:doku_maker/screens/project/new_text_entry_modal.dart';
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
  Widget bottomSheet(String projectId) {
    return NewTextEntryModal(projectId, this);
  }

  @override
  Map<String, dynamic> toJson() => {
        '_id': id,
        'entryType': 'TEXT',
        'title': title,
        'tags': tags,
        'content': text,
        'creationDate': creationDate.toUtc().toIso8601String()
      };
}
