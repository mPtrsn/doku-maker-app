import 'entries/project_entry.dart';

class Project {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<ProjectEntry> entries;
  final List<String> tags;
  final List<String> customTags;
  final List<String> collaborators;
  final String owner;
  final DateTime creationDate;
  final bool disabled;

  const Project(
      {this.id,
      this.title,
      this.description,
      this.imageUrl,
      this.entries,
      this.tags,
      this.customTags,
      this.owner,
      this.collaborators,
      this.creationDate,
      this.disabled});
}
