import 'package:doku_maker/config.dart';
import 'package:doku_maker/models/project/entries/project_video_entry.dart';
import 'package:doku_maker/provider/auth_provider.dart';
import 'package:doku_maker/provider/projects_provider.dart';
import 'package:doku_maker/widgets/adaptive/adaptive_progress_indicator.dart';
import 'package:doku_maker/widgets/doku_document_picker.dart';
import 'package:doku_maker/widgets/video_player.dart';
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
  String _newVideoPath;
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
        _newVideoPath != null &&
        _newVideoPath.isNotEmpty) {
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });
      try {
        if (widget.entry != null) {
          await Provider.of<ProjectsProvider>(context, listen: false)
              .updateEntry(
            widget.projectId,
            ProjectVideoEntry(
              id: widget.entry.id,
              title: _data['title'],
              tags: widget.entry.tags,
              creationDate: widget.entry.creationDate,
              videoUrl: _newVideoPath,
              author: Provider.of<AuthProvider>(context, listen: false).userId,
            ),
          );
        } else {
          await Provider.of<ProjectsProvider>(context, listen: false).addEntry(
            widget.projectId,
            ProjectVideoEntry(
              id: null,
              title: _data['title'],
              tags: [],
              creationDate: DateTime.now(),
              videoUrl: _newVideoPath,
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
    return Scaffold(
      appBar: AppBar(
        title: Text('New Video Entry'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Container(
        child: _isLoading
            ? Center(child: AdaptiveProgressIndicator())
            : Container(
                padding: const EdgeInsets.all(8.0),
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
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
                                type: PickerType.Video,
                                onUploaded: (String path) {
                                  setState(() {
                                    _newVideoPath = path;
                                  });
                                },
                                showPreview: false,
                              )),
                        ],
                      ),
                      if (_newVideoPath != null && _newVideoPath.isNotEmpty)
                        Expanded(
                          child: Container(
                            child: VideoPlayer.network(
                              Config.couchdbURL + _newVideoPath,
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
