import 'dart:convert';

import 'package:doku_maker/models/entries/project_entry.dart';
import 'package:doku_maker/models/entries/project_image_entry.dart';
import 'package:doku_maker/models/entries/project_text_entry.dart';
import 'package:doku_maker/models/project.dart';

///////////////////////////////////////////////////
///    TO JSON
///////////////////////////////////////////////////
String projectToJson(Project project) {
  Map<String, dynamic> map = {
    'project': {
      'ID': project.id != null ? project.id : '',
      'title': project.title,
      'description': project.description,
      'imageUrl': project.imageUrl,
      'entries': project.entries.map((e) => e.toJson()).toList(),
      'tags': project.tags,
      'customTags': project.customTags,
      'owner': project.owner,
      'collaborators': project.collaborators,
      'creationDate': project.creationDate.toIso8601String(),
      'disabled': project.disabled,
    }
  };

  return json.encode(map);
}

///////////////////////////////////////////////////
///    FROM JSON
///////////////////////////////////////////////////
Project projectFromJson(Map<String, dynamic> json) {
  List<ProjectEntry> entries = (json['entries'] as List<dynamic>) == null
      ? []
      : (json['entries'] as List<dynamic>)
          .map((e) => entryFromJson(e))
          .toList()
          .reversed
          .toList();
  return Project(
    id: json['ID'],
    title: json['title'],
    description: json['description'],
    imageUrl: json['imageUrl'],
    entries: entries,
    tags: new List<String>.from(json['tags'] == null ? [] : json['tags']),
    customTags: new List<String>.from(
        json['customTags'] == null ? [] : json['customTags']),
    owner: json['owner'],
    collaborators: new List<String>.from(
        json['collaborators'] == null ? [] : json['collaborators']),
    creationDate: DateTime.parse(json['creationDate']),
    disabled: json['disabled'],
  );
}

// TODO:  'VIDEO', 'AUDIO', 'SKETCH', 'LINK'
ProjectEntry entryFromJson(dynamic entry) {
  var type = entry['type'];
  switch (type) {
    case 'TEXT':
      return ProjectTextEntry(
        id: entry['_id'],
        title: entry['title'],
        tags: new List<String>.from(entry['tags'] == null ? [] : entry['tags']),
        text: entry['content'],
        creationDate: DateTime.parse(entry['creationDate']),
      );
    case 'IMAGE':
      return ProjectImageEntry(
        id: entry['_id'],
        title: entry['title'],
        tags: new List<String>.from(entry['tags'] == null ? [] : entry['tags']),
        imageUrl: entry['content'],
        creationDate: DateTime.parse(entry['creationDate']),
      );
    case 'VIDEO':
      return ProjectImageEntry(
        id: entry['_id'],
        title: entry['title'],
        tags: new List<String>.from(entry['tags'] == null ? [] : entry['tags']),
        imageUrl: entry['content'],
        creationDate: DateTime.parse(entry['creationDate']),
      );
    case 'AUDIO':
      return ProjectImageEntry(
        id: entry['_id'],
        title: entry['title'],
        tags: new List<String>.from(entry['tags'] == null ? [] : entry['tags']),
        imageUrl: entry['content'],
        creationDate: DateTime.parse(entry['creationDate']),
      );
    case 'SKETCH':
      return ProjectImageEntry(
        id: entry['_id'],
        title: entry['title'],
        tags: new List<String>.from(entry['tags'] == null ? [] : entry['tags']),
        imageUrl: entry['content'],
        creationDate: DateTime.parse(entry['creationDate']),
      );
    case 'LINK':
      return ProjectImageEntry(
        id: entry['_id'],
        title: entry['title'],
        tags: new List<String>.from(entry['tags'] == null ? [] : entry['tags']),
        imageUrl: entry['content'],
        creationDate: DateTime.parse(entry['creationDate']),
      );
    default:
      return null;
  }
}
