import 'package:flutter/material.dart';

import '../project_tag.dart';

class ProjectEntry {
  final int id;
  final String title;
  final List<ProjectTag> tags;

  const ProjectEntry(this.id, this.title, this.tags);

  Widget get displayWidget {
    return null;
  }
}
