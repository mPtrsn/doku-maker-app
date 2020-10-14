import 'entries/project_entry.dart';

class Project {
  final int id;
  final String title;
  final String owner;
  final List<String> collaborators;
  final List<ProjectEntry> entries;

  const Project(
      this.id, this.title, this.owner, this.collaborators, this.entries);
}
