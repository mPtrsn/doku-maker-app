import 'package:doku_maker/screens/project/new_image_entry_modal.dart';
import 'package:flutter/material.dart';

import '../../../config.dart';
import 'project_entry.dart';

class ProjectImageEntry extends ProjectEntry {
  final String imageUrl;

  ProjectImageEntry({
    String id,
    String title,
    List<String> tags,
    DateTime creationDate,
    String author,
    this.imageUrl,
  }) : super(id, title, tags, creationDate, author);

  @override
  Widget get displayWidget {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.network(
        Config.couchdbURL + this.imageUrl,
        fit: BoxFit.contain,
      ),
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
        'creationDate': creationDate.toUtc().toIso8601String(),
        'author': author,
      };
}
