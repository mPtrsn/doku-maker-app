import 'dart:convert';

import 'package:doku_maker/models/project.dart';
import 'package:doku_maker/provider/json_converter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ProjectsProvider with ChangeNotifier {
  List<Project> _projects = [];

  final String userId;

  ProjectsProvider(this.userId, this._projects);

  List<Project> get projects {
    return [..._projects];
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
    print('Create Project resulted body: ');
    print(body);
    var response = await http.post(
      'http://10.0.2.2:3000/project/full',
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print(response);
    _projects.add(
        projectFromJson(json.decode(response.body) as Map<String, dynamic>));
    notifyListeners();
  }

  Future getAllProjects() async {
    // try {
    http.Response response = await http.get('http://10.0.2.2:3000/project');
    var extractedData = json.decode(response.body) as List<dynamic>;
    if (extractedData == null) {
      notifyListeners();
      return;
    }
    List<Project> loadedProjects = [];
    extractedData.forEach((e) => {loadedProjects.add(projectFromJson(e))});
    _projects = loadedProjects;
    // } catch (error) {
    //   throw error;
    // }
    notifyListeners();
  }

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

  Project findById(String projectId) {
    return projects.firstWhere((element) => element.id == projectId);
  }
}
