import 'entries/project_entry.dart';

class Project {
  final String id;
  String title;
  String description;
  String imageUrl;
  List<ProjectEntry> entries;
  List<String> tags;
  List<String> customTags;
  List<String> collaborators;
  List<String> owners;
  final DateTime creationDate;
  DateTime lastUpdated;
  bool disabled;

  Project(
      {this.id,
      this.title,
      this.description,
      this.imageUrl,
      this.entries,
      this.tags,
      this.customTags,
      this.owners,
      this.collaborators,
      this.creationDate,
      this.lastUpdated,
      this.disabled});

  Project.clone(Project oldProject)
      : this(
          id: oldProject.id,
          title: oldProject.title,
          description: oldProject.description,
          imageUrl: oldProject.imageUrl,
          entries: oldProject.entries,
          tags: oldProject.tags,
          customTags: oldProject.customTags,
          owners: oldProject.owners,
          collaborators: oldProject.collaborators,
          creationDate: oldProject.creationDate,
          lastUpdated: oldProject.lastUpdated,
          disabled: oldProject.disabled,
        );

  bool equals(Project other) {
    return this.id == other.id &&
        this.title == other.title &&
        this.description == other.description &&
        this.imageUrl == other.imageUrl &&
        this.entries == other.entries &&
        this.tags == other.tags &&
        this.customTags == other.customTags &&
        this.owners == other.owners &&
        this.collaborators == other.collaborators &&
        this.creationDate == other.creationDate &&
        this.lastUpdated == other.lastUpdated &&
        this.disabled == other.disabled;
  }
}
