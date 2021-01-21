import 'package:doku_maker/models/project/project.dart';
import 'package:doku_maker/provider/projects_provider.dart';
import 'package:doku_maker/widgets/chip_list.dart';
import 'package:doku_maker/widgets/editable_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectSettingsScreen extends StatefulWidget {
  static const String routeName = '/project-settings';
  @override
  _ProjectSettingsScreenState createState() => _ProjectSettingsScreenState();
}

class _ProjectSettingsScreenState extends State<ProjectSettingsScreen> {
  Project _project;
  Project _newProject;

  bool get _changesMade {
    return !_project.equals(_newProject);
  }

  void _init() {
    if (_newProject == null) {
      _newProject = Project.clone(_project);
    }
  }

  void _onSave() {
    setState(() {});
  }

  Future _onSaveProject() async {
    print(_newProject.tags);

    await Provider.of<ProjectsProvider>(context, listen: false)
        .performUpdate(_newProject);
    setState(() {
      _newProject = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    _project = ModalRoute.of(context).settings.arguments as Project;
    _init();

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Project Settings"),
            actions: [
              IconButton(
                icon: Icon(Icons.save),
                onPressed: _onSaveProject,
              )
            ],
          ),
          body: _project == null
              ? Text("Project == null")
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'project name',
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          ),
                          EditAbleText(
                            _newProject.title,
                            onChange: (text) => _newProject.title = text,
                            onSave: _onSave,
                            style: TextStyle(fontSize: 26),
                          ),
                          Divider(thickness: 2),
                          Text(
                            'description',
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          ),
                          EditAbleText(
                            _newProject.description,
                            onChange: (text) => _newProject.description = text,
                            onSave: _onSave,
                          ),

                          Divider(thickness: 2),
                          // OWNERS
                          EditableChipList(
                            chips: _newProject.owners,
                            onDone: (newChips) => _newProject.owners = newChips,
                            title: 'Owners',
                          ),

                          Divider(thickness: 2),
                          EditableChipList(
                            chips: _newProject.collaborators,
                            onDone: (newChips) =>
                                _newProject.collaborators = newChips,
                            title: 'Collaborators',
                          ),

                          Divider(thickness: 2),

                          // Project Tags
                          EditableChipList(
                            chips: _newProject.tags,
                            onDone: (newChips) => _newProject.tags = newChips,
                            title: 'Project Tags',
                          ),

                          // custom tags
                          Divider(thickness: 2),
                          EditableChipList(
                            chips: _newProject.customTags,
                            onDone: (newChips) =>
                                _newProject.customTags = newChips,
                            title: 'Custom Tags',
                          ),

                          Divider(thickness: 2),
                          OutlineButton(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                            onPressed: () {}, // TODO Delete Dialog
                            child: Text('Delete Project'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
        ),
        onWillPop: () {
          if (_changesMade == false) {
            return Future.value(true);
          } else {
            return showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("Unsaved Changes"),
                content: Text("There are unsaved Changes"),
                actions: [
                  FlatButton(
                    child: Text('Continiue without saving'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                  RaisedButton(
                    child: Text('save Changes'),
                    onPressed: () async {
                      // save Changes
                      await _onSaveProject();
                      Navigator.of(context).pop(true);
                    },
                  ),
                  RaisedButton(
                    child: Text('Cancle'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  )
                ],
              ),
            );
          }
        });
  }
}
