import 'dart:convert';

import 'package:doku_maker/config.dart';
import 'package:doku_maker/exceptions/html_exception.dart';
import 'package:doku_maker/models/project/entries/project_entry.dart';
import 'package:doku_maker/models/project/project.dart';
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
    return Config.backendURL + '/v1/projects';
  }

  Map<String, String> get jsonUTF8Header {
    return {"Content-Type": "application/json; charset=utf-8"};
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
      imageUrl: imageUrl.isNotEmpty ? imageUrl : Config.defaultImagePath,
      entries: [],
      tags: [],
      customTags: [],
      owners: [userId],
      collaborators: [],
      creationDate: DateTime.now(),
      lastUpdated: DateTime.now(),
      disabled: false,
    );
    var body = projectToJson(newProject);
    var response = await http.put(
      baseUrl + '/full',
      headers: jsonUTF8Header,
      body: body,
    );
    //print(response.body);
    _projects.add(
        projectFromJson(json.decode(response.body) as Map<String, dynamic>));
    notifyListeners();
  }

  Future getAllProjects() async {
    // try {
    http.Response response = await http.get(
      baseUrl + '/$userId',
      headers: jsonUTF8Header,
    );
    var extractedData = json.decode(response.body) as List<dynamic>;
    if (extractedData == null) {
      notifyListeners();
      return;
    }
    List<Project> loadedProjects = [];
    extractedData
        .forEach((e) => {loadedProjects.insert(0, projectFromJson(e))});
    _projects = loadedProjects
      ..sort((Project a, Project b) => b.lastUpdated.compareTo(a.lastUpdated));
    // } catch (error) {
    //   throw error;
    // }
    notifyListeners();
  }

  Future addEntry(String projectId, ProjectEntry entry) async {
    Project old = findById(projectId);
    old.entries.add(entry);
    try {
      await performUpdate(old);
    } catch (error) {
      old.entries.remove(entry);
    }

    notifyListeners();
  }

  Future updateEntry(String projectId, ProjectEntry entry) async {
    Project p = findById(projectId);
    var indexWhere = p.entries.indexWhere((element) => element.id == entry.id);
    p.entries[indexWhere] = entry;
    await performUpdate(p);
    notifyListeners();
  }

  Future<void> removeEntry(String projectId, String id) async {
    Project p = findById(projectId);
    p.entries.removeWhere((e) => e.id == id);
    await performUpdate(p);
    notifyListeners();
  }

  Future performUpdate(Project project) async {
    project.lastUpdated = DateTime.now();
    String jsonStr = projectToJson(project);
    http.Response response = await http.post('$baseUrl/${project.id}',
        headers: jsonUTF8Header, body: jsonStr);
    if (response.statusCode != 200) {
      print('Perform Update Failed: ' + response.body);
      throw HtmlException(response.statusCode.toString(), response.body);
    }
    int idx = _projects.indexWhere((element) => element.id == project.id);
    _projects[idx] =
        projectFromJson(json.decode(response.body) as Map<String, dynamic>);
    notifyListeners();
  }

  Future deleteProject(String id) async {
    http.Response response = await http.delete('$baseUrl/$id');
    if (response.statusCode != 200) {
      print('Perform Update Failed: ' + response.body);
      throw HtmlException(response.statusCode.toString(), response.body);
    } else {
      _projects.removeWhere((element) => element.id == id);
      notifyListeners();
    }
  }
}
