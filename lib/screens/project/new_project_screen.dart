import 'dart:io';

import 'package:doku_maker/provider/projects_provider.dart';
import 'package:doku_maker/provider/upload_service.dart';
import 'package:doku_maker/widgets/doku_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  void onImageSelected(File image) {
    setState(() {
      _imagePath = image.path;
    });
  }

  Future<void> _createNewProject() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      // make rest call
      String imageUrl = '';
      try {
        imageUrl =
            await UploadService.uploadImage(_projectData['title'], _imagePath);
      } catch (error) {
        print('Error Uploading Projectimage');
        print(error.toString());
        return;
      }
      if (imageUrl.isNotEmpty) {
        try {
          await Provider.of<ProjectsProvider>(context, listen: false)
              .createProject(
                  _projectData['title'], _projectData['description'], imageUrl);
          Navigator.of(context).pop();
        } catch (error) {
          print('Error Creating Project');
          print(error.toString());
          return;
        }
      } else {
        print("ImageURL from server is empty");
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
              DokuImagePicker(
                onSelected: onImageSelected,
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
