import 'package:doku_maker/models/project.dart';
import 'package:doku_maker/widgets/editable_text.dart';
import 'package:flutter/material.dart';

class ProjectSettingsScreen extends StatefulWidget {
  static const String routeName = '/project-settings';
  @override
  _ProjectSettingsScreenState createState() => _ProjectSettingsScreenState();
}

class _ProjectSettingsScreenState extends State<ProjectSettingsScreen> {
  Project _project;

  String _newTitle = '';
  String _newDescription = '';
  List<String> _newCollabList = [];
  List<String> _newTagList = [];
  List<String> _newCustomTagList = [];

  bool get _changesMade {
    return _newTitle != _project.title ||
        _newDescription != _project.description ||
        _newCollabList != _project.collaborators ||
        _newTagList != _project.tags ||
        _newCustomTagList != _project.customTags;
  }

  void _init() {
    if (_newTitle == '') {
      _newTitle = _project.title;
      _newDescription = _project.description;
      _newCollabList = _project.collaborators;
      _newTagList = _project.tags;
      _newCustomTagList = _project.customTags;
    }
  }

  void _onSave() {
    setState(() {});
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
                onPressed: () {}, // TODO SAVE SETTINGS
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
                            _newTitle,
                            onChange: (text) => _newTitle = text,
                            onSave: _onSave,
                            style: TextStyle(fontSize: 26),
                          ),
                          Divider(),
                          Text(
                            'description',
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          ),
                          EditAbleText(
                            _newDescription,
                            onChange: (text) => _newDescription = text,
                            onSave: _onSave,
                          ),

                          Text('Owner: ${_project.owner}'),
                          Text(' a, b, c, d, e'),
                          OutlineButton(
                            onPressed: () {}, // TODO collab bottom modal
                            child: Text('Collaborators'),
                          ),

                          OutlineButton(
                            onPressed: () {}, // TODO label bottom modal
                            child: Text('project labels'),
                          ),
                          // tags
                          OutlineButton(
                            onPressed: () {}, // TODO custom label bottom modal
                            child: Text('entity labels'),
                          ),
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
                    onPressed: () {
                      // save Changes
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
