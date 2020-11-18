import 'package:doku_maker/models/entries/project_entry.dart';
import 'package:doku_maker/screens/modals/new_image_entry_modal.dart';
import 'package:flutter/material.dart';

class ProjectImageEntry extends ProjectEntry {
  final String imageUrl;

  const ProjectImageEntry({
    String id,
    String title,
    List<String> tags,
    DateTime creationDate,
    this.imageUrl,
  }) : super(id, title, tags, creationDate);

  @override
  Widget get displayWidget {
    return Image.network(
      this.imageUrl,
      headers: {'Authorization': 'Basic cmVhZGVyOnJlYWRlcg=='},
      fit: BoxFit.cover,
    );
  }

  @override
  Widget bottomSheet(String projectId) {
    return NewImageEntryModal(projectId, this);
  }

  @override
  Map<String, dynamic> toJson() => {
        '_id': id,
        'type': 'IMAGE',
        'title': title,
        'tags': tags,
        'content': imageUrl,
        'creationDate': creationDate.toIso8601String()
      };
}
