import 'package:flutter/material.dart';

import '../project_tag.dart';

class ProjectEntry {
  final String id;
  final String title;
  final List<ProjectTag> tags;
  final DateTime creationDate;

  const ProjectEntry(
    this.id,
    this.title,
    this.tags,
    this.creationDate,
  );

  Widget get displayWidget {
    return null;
  }
}
