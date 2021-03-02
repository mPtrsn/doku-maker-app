import 'package:doku_maker/provider/projects_provider.dart';
import 'package:doku_maker/widgets/doku_document_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config.dart';

class NewProjectScreen extends StatefulWidget {
  static const String routeName = '/new-project';
  @override
  _NewProjectScreenState createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, dynamic> _projectData = {
    'title': '',
    'description': '',
  };

  String _imagePath = '';

  Future<void> _createNewProject() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        await Provider.of<ProjectsProvider>(context, listen: false)
            .createProject(_projectData['title'], _projectData['description'],
                _imagePath.isNotEmpty ? _imagePath : Config.defaultImagePath);
        Navigator.of(context).pop();
      } catch (error) {
        print('Error Creating Project');
        print(error.toString());
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Project'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _createNewProject,
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              DocumentPicker(
                type: PickerType.Image,
                onUploaded: (path) => setState(() {
                  _imagePath = path;
                }),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Title!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _projectData['title'] = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                onSaved: (value) {
                  _projectData['description'] = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
