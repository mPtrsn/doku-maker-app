import 'dart:convert';

import 'package:doku_maker/models/entries/project_entry.dart';
import 'package:doku_maker/models/project.dart';
import 'package:doku_maker/services/json_converter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ProjectsProvider with ChangeNotifier {
  List<Project> _projects = [];

  final String userId;

  ProjectsProvider(this.userId, this._projects);

  List<Project> get projects {
    return [..._projects];
  }

  String get baseUrl {
    return 'http://10.0.2.2:3000/v1/projects';
  }

  String getUrl(String id) {
    return baseUrl + '/$id';
  }

  Project findById(String projectId) {
    return _projects.firstWhere((element) => element.id == projectId);
  }

  Project findByEntryId(String entryId) {
    return _projects.firstWhere((element) =>
        element.entries.where((entry) => entry.id == entryId).isNotEmpty);
  }

  Future createProject(
    String title,
    String description,
    String imageUrl,
  ) async {
    Project newProject = Project(
      id: null,
      title: title,
      description: description,
      imageUrl: imageUrl,
      entries: [],
      tags: [],
      customTags: [],
      owner: userId,
      collaborators: [],
      creationDate: DateTime.now(),
      disabled: false,
    );
    var body = projectToJson(newProject);
    var response = await http.put(
      baseUrl + '/full',
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    _projects.add(
        projectFromJson(json.decode(response.body) as Map<String, dynamic>));
    notifyListeners();
  }

  Future getAllProjects() async {
    // try {
    http.Response response = await http.get(baseUrl + '/$userId');
    var extractedData = json.decode(response.body) as List<dynamic>;
    if (extractedData == null) {
      notifyListeners();
      return;
    }
    List<Project> loadedProjects = [];
    extractedData
        .forEach((e) => {loadedProjects.insert(0, projectFromJson(e))});
    _projects = loadedProjects;
    // } catch (error) {
    //   throw error;
    // }
    notifyListeners();
  }

  Future addEntry(String projectId, ProjectEntry entry) async {
    Project old = findById(projectId);
    old.entries.add(entry);
    await performUpdate(old);
    notifyListeners();
  }

  Future<void> removeEntry(String projectId, String id) async {
    Project p = findById(projectId);
    p.entries.removeWhere((e) => e.id == id);
    await performUpdate(p);
    notifyListeners();
  }

  Future performUpdate(Project project) async {
    String jsonStr = projectToJson(project);
    http.Response response = await http.post('$baseUrl/${project.id}',
        headers: {"Content-Type": "application/json"}, body: jsonStr);
    if (response.statusCode >= 400) {
      print('Perform Update Failed: ' + response.body);
      return null;
    }
    int idx = _projects.indexWhere((element) => element.id == project.id);
    _projects[idx] =
        projectFromJson(json.decode(response.body) as Map<String, dynamic>);
    notifyListeners();
  }

/*
  Future addEntry(
    String projectId,
    String title,
    String type,
    String content,
  ) async {
    try {
      String jsonStr = json.encode(
        {
          'entry': {
            'entry': 'entry',
            'title': title,
            'tags': [],
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
      _projects[idx] =
          projectFromJson(json.decode(response.body) as Map<String, dynamic>);
    } catch (error) {
      print(error.toString());
    }

    notifyListeners();
  }

  

  Future<void> removeEntry(String projectId, String id) async {
    var url = 'http://10.0.2.2:3000/project/$projectId/entry/$id';
    var response = await http.delete(url);
    if (response.statusCode >= 400) {
      throw Exception();
    }
    _projects
        .firstWhere((element) => element.id == projectId)
        .entries
        .removeWhere((e) => e.id == id);
    notifyListeners();
  }

  Future<void> updateEntry(String projectId, ProjectTextEntry entry) async {
    var url = 'http://10.0.2.2:3000/project/$projectId/entry/${entry.id}';
    var response = await http.post(url, body: json.encode(entry.toJson()));
    if (response.statusCode >= 400) {
      throw Exception();
    }
    // TODO rebuild project from response
    notifyListeners();
  }
*/
}
