import 'package:doku_maker/models/room/RoomEntry.dart';
import 'package:doku_maker/provider/auth_provider.dart';
import 'package:doku_maker/provider/room_provider.dart';
import 'package:doku_maker/widgets/adaptive/adaptive_progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config.dart';

class NewRoomEntryDialog extends StatefulWidget {
  final String roomId = Config.smartareaID;

  NewRoomEntryDialog();

  @override
  _NewRoomEntryDialogState createState() => _NewRoomEntryDialogState();
}

class _NewRoomEntryDialogState extends State<NewRoomEntryDialog> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('New Entry'),
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
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
