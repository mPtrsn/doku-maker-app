import 'package:doku_maker/provider/projects_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewTextEntryModal extends StatefulWidget {
  final String projectId;

  const NewTextEntryModal(this.projectId);

  @override
  _NewTextEntryModalState createState() => _NewTextEntryModalState();
}

class _NewTextEntryModalState extends State<NewTextEntryModal> {
  final _form = GlobalKey<FormState>();

  var _data = {'title': '', 'text': ''};
  var _isLoading = false;
  Future _saveForm() async {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<ProjectsProvider>(context, listen: false)
            .addEntry(widget.projectId, _data['title'], 'TEXT', _data['text']);
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
                              'New Text Entry',
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
                        validator: (value) {
                          return null;
                        },
                        onSaved: (newValue) {
                          _data['title'] = newValue;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Text'),
                        maxLines: 2,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          return null;
                        },
                        onSaved: (newValue) {
                          _data['text'] = newValue;
                        },
                        onFieldSubmitted: (value) => _saveForm(),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
