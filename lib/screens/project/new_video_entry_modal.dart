import 'dart:io';

import 'package:doku_maker/models/project/entries/project_image_entry.dart';
import 'package:doku_maker/models/project/entries/project_video_entry.dart';
import 'package:doku_maker/provider/auth_provider.dart';
import 'package:doku_maker/provider/projects_provider.dart';
import 'package:doku_maker/provider/upload_service.dart';
import 'package:doku_maker/widgets/adaptive/adaptive_progress_indicator.dart';
import 'package:doku_maker/widgets/doku_image_picker.dart';
import 'package:doku_maker/widgets/doku_video_picker.dart';
import 'package:doku_maker/widgets/video_player_dialog.dart';
import 'package:doku_maker/widgets/video_player_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewVideoEntryModal extends StatefulWidget {
  final String projectId;
  final ProjectVideoEntry entry;
  const NewVideoEntryModal(this.projectId, [this.entry]);

  @override
  _NewVideoEntryModalState createState() => _NewVideoEntryModalState();
}

class _NewVideoEntryModalState extends State<NewVideoEntryModal> {
  final _form = GlobalKey<FormState>();

  var _data = {'title': ''};
  File _newVideo;
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
    if (_form.currentState.validate()) {
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });
      try {
        String videoUrl =
            await UploadService.uploadVideo(_data['title'], _newVideo.path);
        if (widget.entry != null) {
          await Provider.of<ProjectsProvider>(context, listen: false)
              .updateEntry(
            widget.projectId,
            ProjectVideoEntry(
              id: widget.entry.id,
              title: _data['title'],
              tags: widget.entry.tags,
              creationDate: widget.entry.creationDate,
              videoUrl: videoUrl,
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
              imageUrl: videoUrl,
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
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'New Image Entry',
                                  style: TextStyle(fontSize: 26),
                                  textAlign: TextAlign.center,
                                ),
                                ElevatedButton(
                                  onPressed: () => _saveForm(),
                                  child: Text('Save'),
                                  style: TextButton.styleFrom(
                                      primary: Theme.of(context).accentColor),
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
                              child: DokuVideoPicker(
                                onSelected: (File image) {
                                  setState(() {
                                    _newVideo = File(image.path);
                                  });
                                },
                                showPreview: false,
                              )),
                        ],
                      ),
                      if (_newVideo != null)
                        Container(
                          child: VideoPlayerPreview.file(
                            _newVideo,
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
