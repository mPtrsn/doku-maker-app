import 'dart:convert';

import 'package:doku_maker/models/entries/project_entry.dart';
import 'package:doku_maker/models/entries/project_image_entry.dart';
import 'package:doku_maker/models/entries/project_text_entry.dart';
import 'package:doku_maker/models/project.dart';
import 'package:doku_maker/models/project_settings.dart';
import 'package:doku_maker/models/project_tag.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ProjectsProvider with ChangeNotifier {
  List<Project> _projects = [];

  final String userId;

  ProjectsProvider(this.userId, this._projects);

  List<Project> get projects {
    return [..._projects];
  }

  Future createProject(String projectName) async {
    Project newProject = Project(
      null,
      projectName,
      '',
      [],
      [],
      null,
      userId,
      [],
      DateTime.now(),
    );
    var response = await http.post('http://10.0.2.2:3000/project',
        body: json.encode(newProject));
    print(response);
  }

  Future getAllProjects() async {
    http.Response response = await http.get('http://10.0.2.2:3000/project');
    var extractedData = json.decode(response.body) as List<dynamic>;
    if (extractedData == null) {
      return;
    }

    List<Project> loadedProjects = [];
    extractedData.forEach((e) => {loadedProjects.add(_mapToProject(e))});
    _projects = loadedProjects;
    notifyListeners();
  }

  Future addEntry(
    String projectId,
    String title,
    String type,
    String content,
  ) async {
    // http://localhost:3000/project/5fa04b479d6cbb3994202da2/entry
    try {
      String jsonStr = json.encode(
        {
          'entry': {
            'entry': 'entry',
            'title': title,
            'type': type,
            'content': content,
            'creationDate': DateTime.now().toIso8601String(),
          }
        },
      );

      http.Response response = await http.put(
          'http://10.0.2.2:3000/project/$projectId/entry',
          headers: {"Content-Type": "application/json"},
          body: jsonStr);
      if (response.statusCode >= 400) {
        print(response.body);
        return null;
      }

      int idx = _projects.indexWhere((element) => element.id == projectId);
      _projects[idx] = _toProject(response);
    } catch (error) {
      print(error.toString());
    }

    notifyListeners();
  }

  Project _toProject(http.Response response) {
    var extractedData = json.decode(response.body) as dynamic;
    return _mapToProject(extractedData);
  }

  Project _mapToProject(dynamic project) {
    List<ProjectEntry> entries = [];
    List<ProjectTag> tags = [];
    (project['entries'] as List<dynamic>)
        .forEach((e) => entries.add(_mapToProjectEntry(e)));
    return Project(
      project['ID'],
      project['title'],
      project['description'],
      entries,
      tags,
      ProjectSettings([]), //e['settings'],
      project['owner'],
      [], //e['collaborators'],
      DateTime.parse(project['creationDate']),
    );
  }

// 'TEXT', 'IMAGE', 'VIDEO', 'AUDIO', 'SKETCH', 'LINK'
  ProjectEntry _mapToProjectEntry(dynamic entry) {
    var type = entry['type'];
    switch (type) {
      case 'TEXT':
        return ProjectTextEntry(
          id: entry['_id'],
          title: entry['title'],
          tags: [],
          text: entry['content'],
          creationDate: DateTime.parse(entry['creationDate']),
        );
      case 'IMAGE':
        return ProjectImageEntry(
          id: entry['_id'],
          title: entry['title'],
          tags: [],
          imageUrl: entry['content'],
          creationDate: DateTime.parse(entry['creationDate']),
        );
      case 'VIDEO':
        return ProjectImageEntry(
          id: entry['_id'],
          title: entry['title'],
          tags: [],
          imageUrl: entry['content'],
          creationDate: DateTime.parse(entry['creationDate']),
        );
      case 'AUDIO':
        return ProjectImageEntry(
          id: entry['_id'],
          title: entry['title'],
          tags: [],
          imageUrl: entry['content'],
          creationDate: DateTime.parse(entry['creationDate']),
        );
      case 'SKETCH':
        return ProjectImageEntry(
          id: entry['_id'],
          title: entry['title'],
          tags: [],
          imageUrl: entry['content'],
          creationDate: DateTime.parse(entry['creationDate']),
        );
      case 'LINK':
        return ProjectImageEntry(
          id: entry['_id'],
          title: entry['title'],
          tags: [],
          imageUrl: entry['content'],
          creationDate: DateTime.parse(entry['creationDate']),
        );
      default:
        return null;
    }
  }

  Project findById(String projectId) {
    return projects.firstWhere((element) => element.id == projectId);
  }
}
