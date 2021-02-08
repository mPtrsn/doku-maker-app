import 'package:doku_maker/models/room/RoomEntry.dart';
import 'package:doku_maker/provider/auth_provider.dart';
import 'package:doku_maker/provider/room_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config.dart';

class NewRoomEntryModal extends StatefulWidget {
  final String roomId = Config.smartareaID;

  NewRoomEntryModal();

  @override
  _NewRoomEntryModalState createState() => _NewRoomEntryModalState();
}

class _NewRoomEntryModalState extends State<NewRoomEntryModal> {
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
        await Provider.of<RoomProvider>(context, listen: false).addEntry(
            widget.roomId,
            RoomEntry(
              id: null,
              title: _data['title'],
              tags: [],
              creationDate: DateTime.now().toUtc(),
              text: _data['text'],
              attachments: [],
              author: Provider.of<AuthProvider>(context, listen: false).userId,
            ));
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
                              'New Entry',
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
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Text'),
                        initialValue: _data['text'],
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
