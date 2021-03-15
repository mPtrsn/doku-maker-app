import 'package:doku_maker/config.dart';
import 'package:doku_maker/models/project/project.dart';
import 'package:doku_maker/provider/auth_provider.dart';
import 'package:doku_maker/provider/projects_provider.dart';
import 'package:doku_maker/screens/project/delete_project_modal.dart';
import 'package:doku_maker/screens/project/projects_overview_screen.dart';
import 'package:doku_maker/widgets/chip_list.dart';
import 'package:doku_maker/widgets/doku_document_picker.dart';
import 'package:doku_maker/widgets/doku_image.dart';
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
    await Provider.of<ProjectsProvider>(context, listen: false)
        .performUpdate(_newProject);
    setState(() {
      _newProject = null;
    });
  }

  Future openDeleteModal() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DeleteProjectModal(
        id: _project.id,
        projectName: _project.title,
      ),
    );
  }

  Future _leaveProject() async {
    _newProject.collaborators
        .remove(Provider.of<AuthProvider>(context, listen: false).userId);
    await _onSaveProject();
    _onSave();
    Navigator.of(context)
        .pushReplacementNamed(ProjectsOverviewScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    _project = ModalRoute.of(context).settings.arguments as Project;
    _init();
    bool isOwner = _newProject.owners
        .contains(Provider.of<AuthProvider>(context, listen: false).userId);
    var device = MediaQuery.of(context).size;
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
                          isOwner
                              ? DocumentPicker(
                                  type: PickerType.Image,
                                  onUploaded: (path) {
                                    _newProject.imageUrl = path;
                                  },
                                  currentImagePath: _project.imageUrl,
                                )
                              : DokuImage.network(
                                  Config.couchdbURL + _newProject.imageUrl,
                                  width: device.width * 0.35,
                                  height: device.width * 0.35,
                                  fit: BoxFit.fill,
                                ),
                          Divider(thickness: 2),
                          Text(
                            'project name',
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          ),
                          isOwner
                              ? EditAbleText(
                                  _newProject.title,
                                  onChange: (text) => _newProject.title = text,
                                  onSave: _onSave,
                                  style: TextStyle(fontSize: 26),
                                )
                              : Text(
                                  _newProject.title,
                                  style: TextStyle(fontSize: 26),
                                ),
                          Divider(thickness: 2),
                          Text(
                            'description',
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          ),
                          isOwner
                              ? EditAbleText(
                                  _newProject.description,
                                  onChange: (text) =>
                                      _newProject.description = text,
                                  onSave: _onSave,
                                )
                              : Text(
                                  _newProject.description,
                                  style: TextStyle(fontSize: 26),
                                ),

                          Divider(thickness: 2),
                          // OWNERS
                          EditableChipList(
                            chips: _newProject.owners,
                            onDone: (newChips) => _newProject.owners = newChips,
                            title: 'Owners',
                            canEdit: isOwner,
                          ),

                          Divider(thickness: 2),
                          EditableChipList(
                            chips: _newProject.collaborators,
                            onDone: (newChips) =>
                                _newProject.collaborators = newChips,
                            title: 'Collaborators',
                            canEdit: isOwner,
                          ),

                          Divider(thickness: 2),

                          // Project Tags
                          EditableChipList(
                            chips: _newProject.tags,
                            onDone: (newChips) => _newProject.tags = newChips,
                            title: 'Project Tags',
                            canEdit: isOwner,
                          ),

                          // custom tags
                          Divider(thickness: 2),
                          EditableChipList(
                            chips: _newProject.customTags,
                            onDone: (newChips) =>
                                _newProject.customTags = newChips,
                            title: 'Custom Tags',
                            canEdit: isOwner,
                          ),

                          Divider(thickness: 2),
                          if (isOwner)
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                primary: Colors.red,
                              ),
                              onPressed: openDeleteModal,
                              child: Text('Delete Project'),
                            )
                          else
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                primary: Colors.red,
                              ),
                              onPressed: _leaveProject,
                              child: Text('Leave Project'),
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
                  TextButton(
                    child: Text('Continiue without saving'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                  ElevatedButton(
                    child: Text('Save Changes'),
                    onPressed: () async {
                      // save Changes
                      await _onSaveProject();
                      Navigator.of(context).pop(true);
                    },
                  ),
                  ElevatedButton(
                    child: Text('Cancel'),
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
