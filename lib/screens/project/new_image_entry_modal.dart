import 'dart:io';

import 'package:doku_maker/models/project/entries/project_image_entry.dart';
import 'package:doku_maker/provider/projects_provider.dart';
import 'package:doku_maker/provider/upload_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewImageEntryModal extends StatefulWidget {
  final String projectId;
  final ProjectImageEntry entry;
  const NewImageEntryModal(this.projectId, [this.entry]);

  @override
  _NewImageEntryModalState createState() => _NewImageEntryModalState();
}

class _NewImageEntryModalState extends State<NewImageEntryModal> {
  final _form = GlobalKey<FormState>();

  var _data = {'title': ''};
  File _newImage;
  final _picker = ImagePicker();
  var _isLoading = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.entry != null) {
        _data['title'] = widget.entry.title;
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<void> _takePicture(ImageSource source) async {
    PickedFile _imageFile = await _picker.getImage(
      source: source,
      maxWidth: 600,
    );
    setState(() {
      _newImage = File(_imageFile.path);
    });
  }

  Future _saveForm() async {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });
      try {
        String imageUrl =
            await UploadService.uploadImage(_data['title'], _newImage.path);
        if (widget.entry != null) {
          await Provider.of<ProjectsProvider>(context, listen: false)
              .updateEntry(
                  widget.projectId,
                  ProjectImageEntry(
                      id: widget.entry.id,
                      title: _data['title'],
                      tags: widget.entry.tags,
                      creationDate: widget.entry.creationDate,
                      imageUrl: imageUrl));
        } else {
          await Provider.of<ProjectsProvider>(context, listen: false).addEntry(
              widget.projectId,
              ProjectImageEntry(
                  id: null,
                  title: _data['title'],
                  tags: [],
                  creationDate: DateTime.now(),
                  imageUrl: imageUrl));
        }
      } catch (error) {
        print(error.toString());
      }

      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Card(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'New Image Entry',
                              style: TextStyle(fontSize: 26),
                              textAlign: TextAlign.center,
                            ),
                            RaisedButton(
                              onPressed: () => _saveForm(),
                              child: Text('Save'),
                              color: Theme.of(context).accentColor,
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        initialValue: _data['title'],
                        validator: (value) {
                          return null;
                        },
                        onSaved: (newValue) {
                          _data['title'] = newValue;
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        width: double.infinity,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RaisedButton(
                              onPressed: () =>
                                  _takePicture(ImageSource.gallery),
                              child: Text(
                                'Select a Picture',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            RaisedButton(
                              onPressed: () => _takePicture(ImageSource.camera),
                              child: Text(
                                'Take a Picture',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_newImage != null)
                        Container(
                          child: Image.file(
                            _newImage,
                            width: 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
