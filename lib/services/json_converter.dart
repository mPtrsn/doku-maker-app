import 'dart:convert';

import 'package:doku_maker/models/project/entries/project_entry.dart';
import 'package:doku_maker/models/project/entries/project_image_entry.dart';
import 'package:doku_maker/models/project/entries/project_text_entry.dart';
import 'package:doku_maker/models/project/project.dart';

///////////////////////////////////////////////////
///    TO JSON
///////////////////////////////////////////////////
String projectToJson(Project project) {
  Map<String, dynamic> map = {
    'id': project.id != null ? project.id : '',
    'title': project.title,
    'description': project.description,
    'imageUrl': project.imageUrl,
    'entries': project.entries.map((e) => e.toJson()).toList(),
    'tags': project.tags,
    'customTags': project.customTags,
    'owners': project.owners,
    'collaborators': project.collaborators,
    'creationDate': project.creationDate.toUtc().toIso8601String(),
    'disabled': project.disabled,
  };

  return json.encode(map);
}

///////////////////////////////////////////////////
///    FROM JSON
///////////////////////////////////////////////////
Project projectFromJson(Map<String, dynamic> json) {
  List<ProjectEntry> entries = (json['entries'] as List<dynamic>) == null
      ? []
      : (json['entries'] as List<dynamic>).map((e) => entryFromJson(e)).toList()
    ..sort((ProjectEntry a, ProjectEntry b) =>
        a.creationDate.compareTo(b.creationDate));
  return Project(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    imageUrl: json['imageUrl'],
    entries: entries,
    tags: new List<String>.from(json['tags'] == null ? [] : json['tags']),
    customTags: new List<String>.from(
        json['customTags'] == null ? [] : json['customTags']),
    owners: new List<String>.from(json['owners'] == null ? [] : json['owners']),
    collaborators: new List<String>.from(
        json['collaborators'] == null ? [] : json['collaborators']),
    creationDate: DateTime.parse(json['creationDate']),
    disabled: json['disabled'],
  );
}

ProjectEntry entryFromJson(dynamic entry) {
  var type = entry['entryType'];
  switch (type) {
    case 'TEXT':
      return ProjectTextEntry(
        id: entry['id'],
        title: entry['title'],
        tags: new List<String>.from(entry['tags'] == null ? [] : entry['tags']),
        text: entry['content'],
        creationDate: DateTime.parse(entry['creationDate']),
      );
    case 'IMAGE':
      return ProjectImageEntry(
        id: entry['id'],
        title: entry['title'],
        tags: new List<String>.from(entry['tags'] == null ? [] : entry['tags']),
        imageUrl: entry['content'],
        creationDate: DateTime.parse(entry['creationDate']),
      );
    case 'VIDEO':
      return ProjectImageEntry(
        id: entry['id'],
        title: entry['title'],
        tags: new List<String>.from(entry['tags'] == null ? [] : entry['tags']),
        imageUrl: entry['content'],
        creationDate: DateTime.parse(entry['creationDate']),
      );
    case 'AUDIO':
      return ProjectImageEntry(
        id: entry['id'],
        title: entry['title'],
        tags: new List<String>.from(entry['tags'] == null ? [] : entry['tags']),
        imageUrl: entry['content'],
        creationDate: DateTime.parse(entry['creationDate']),
      );
    case 'SKETCH':
      return ProjectImageEntry(
        id: entry['id'],
        title: entry['title'],
        tags: new List<String>.from(entry['tags'] == null ? [] : entry['tags']),
        imageUrl: entry['content'],
        creationDate: DateTime.parse(entry['creationDate']),
      );
    case 'LINK':
      return ProjectImageEntry(
        id: entry['id'],
        title: entry['title'],
        tags: new List<String>.from(entry['tags'] == null ? [] : entry['tags']),
        imageUrl: entry['content'],
        creationDate: DateTime.parse(entry['creationDate']),
      );
    default:
      print('Error trying to parse Entry');
      return null;
  }
}
