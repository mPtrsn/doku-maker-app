import 'package:doku_maker/models/project/entries/project_text_entry.dart';
import 'package:doku_maker/provider/auth_provider.dart';
import 'package:doku_maker/provider/projects_provider.dart';
import 'package:doku_maker/widgets/adaptive/adaptive_progress_indicator.dart';
import 'package:doku_maker/widgets/project/new_entry_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewTextEntryModal extends StatefulWidget {
  final String projectId;
  final ProjectTextEntry entry;
  const NewTextEntryModal(this.projectId, [this.entry]);

  @override
  _NewTextEntryModalState createState() => _NewTextEntryModalState();
}

class _NewTextEntryModalState extends State<NewTextEntryModal> {
  final _form = GlobalKey<FormState>();

  var _data = {'title': '', 'text': ''};
  var _isLoading = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.entry != null) {
        _data['title'] = widget.entry.title;
        _data['text'] = widget.entry.text;
      }
      setState(() {});
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
        if (widget.entry != null) {
          await Provider.of<ProjectsProvider>(context, listen: false)
              .updateEntry(
            widget.projectId,
            ProjectTextEntry(
              id: widget.entry.id,
              title: _data['title'],
              tags: widget.entry.tags,
              creationDate: widget.entry.creationDate,
              text: _data['text'],
              author: Provider.of<AuthProvider>(context, listen: false).userId,
            ),
          );
        } else {
          await Provider.of<ProjectsProvider>(context, listen: false).addEntry(
            widget.projectId,
            ProjectTextEntry(
              id: null,
              title: _data['title'],
              tags: [],
              creationDate: DateTime.now(),
              text: _data['text'],
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      NewEntryModalHeader(
                        title: 'New Text Entry',
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Text'),
                            initialValue: _data['text'],
                            maxLines: null,
                            minLines: null,
                            expands: true,
                            keyboardType: TextInputType.multiline,
                            validator: (value) {
                              return value.isEmpty ? 'Provide a text' : null;
                            },
                            onSaved: (newValue) {
                              _data['text'] = newValue;
                            },
                            onFieldSubmitted: (value) => _saveForm(),
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
