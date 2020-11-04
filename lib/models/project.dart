import 'package:doku_maker/models/project_settings.dart';
import 'package:doku_maker/models/project_tag.dart';

import 'entries/project_entry.dart';

class Project {
  final String id;
  final String title;
  final String description;
  final List<ProjectEntry> entries;
  final List<ProjectTag> tags;
  final ProjectSettings settings;
  final List<String> collaborators;
  final String owner;
  final DateTime creationDate;

  const Project(
    this.id,
    this.title,
    this.description,
    this.entries,
    this.tags,
    this.settings,
    this.owner,
    this.collaborators,
    this.creationDate,
  );
}
