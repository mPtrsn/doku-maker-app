import 'package:doku_maker/models/project/entries/project_image_entry.dart';
import 'package:doku_maker/provider/auth_provider.dart';
import 'package:doku_maker/provider/projects_provider.dart';
import 'package:doku_maker/widgets/adaptive/adaptive_progress_indicator.dart';
import 'package:doku_maker/widgets/doku_document_picker.dart';
import 'package:doku_maker/widgets/doku_image.dart';
import 'package:doku_maker/widgets/project/new_entry_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config.dart';

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
  String _newImagePath;
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

  Future _saveForm() async {
    if (_form.currentState.validate() &&
        _newImagePath != null &&
        _newImagePath.isNotEmpty) {
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });
      try {
        if (widget.entry != null) {
          await Provider.of<ProjectsProvider>(context, listen: false)
              .updateEntry(
            widget.projectId,
            ProjectImageEntry(
              id: widget.entry.id,
              title: _data['title'],
              tags: widget.entry.tags,
              creationDate: widget.entry.creationDate,
              imageUrl: _newImagePath,
              author: Provider.of<AuthProvider>(context, listen: false).userId,
            ),
          );
        } else {
          await Provider.of<ProjectsProvider>(context, listen: false).addEntry(
            widget.projectId,
            ProjectImageEntry(
              id: null,
              title: _data['title'],
              tags: [],
              creationDate: DateTime.now(),
              imageUrl: _newImagePath,
              author: Provider.of<AuthProvider>(context, listen: false).userId,
            ),
          );
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
      height: MediaQuery.of(context).size.height * 0.6,
      child: Card(
        child: _isLoading
            ? Center(child: AdaptiveProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          NewEntryModalHeader(
                            title: 'New Image Entry',
                            saveForm: _saveForm,
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Title'),
                            textInputAction: TextInputAction.next,
                            initialValue: _data['title'],
                            validator: (value) {
                              return value.isEmpty ? 'Provide a title' : null;
                            },
                            onSaved: (newValue) {
                              _data['title'] = newValue;
                            },
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 15),
                              width: double.infinity,
                              height: 50,
                              child: DocumentPicker(
                                type: PickerType.Image,
                                onUploaded: (String path) {
                                  setState(() {
                                    _newImagePath = path;
                                  });
                                },
                                showPreview: false,
                              )),
                        ],
                      ),
                      if (_newImagePath != null && _newImagePath.isNotEmpty)
                        Expanded(
                          child: Container(
                            child: DokuImage.network(
                              Config.couchdbURL + _newImagePath,
                              width: 250,
                              fit: BoxFit.contain,
                            ),
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
