import 'package:doku_maker/screens/project/new_image_entry_modal.dart';
import 'package:flutter/material.dart';

import '../../../config.dart';
import 'project_entry.dart';

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
      Config.couchdbURL + this.imageUrl,
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
        'entryType': 'IMAGE',
        'title': title,
        'tags': tags,
        'content': imageUrl,
        'creationDate': creationDate.toUtc().toIso8601String()
      };
}
