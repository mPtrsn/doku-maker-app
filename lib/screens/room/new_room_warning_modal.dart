import 'package:doku_maker/models/room/RoomWarning.dart';
import 'package:doku_maker/provider/auth_provider.dart';
import 'package:doku_maker/provider/room_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config.dart';

class NewRoomWarningModal extends StatefulWidget {
  final String roomId = Config.smartareaID;
  final RoomWarning warning;
  NewRoomWarningModal([this.warning]);

  @override
  _NewRoomWarningModalState createState() => _NewRoomWarningModalState();
}

class _NewRoomWarningModalState extends State<NewRoomWarningModal> {
  final _form = GlobalKey<FormState>();

  var _data = {'level': 'INFO', 'text': ''};
  var _isLoading = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.warning != null) {
        _data['level'] = widget.warning.level;
        _data['text'] = widget.warning.text;
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
        if (widget.warning != null) {
          await Provider.of<RoomProvider>(context, listen: false).updateWarning(
              "roomId TODO",
              RoomWarning(
                  id: widget.warning.id,
                  level: _data['level'],
                  author: widget.warning.author,
                  creationDate: widget.warning.creationDate,
                  text: _data['text']));
        } else {
          await Provider.of<RoomProvider>(context, listen: false).addWarning(
              widget.roomId,
              RoomWarning(
                id: null,
                level: _data['level'],
                creationDate: DateTime.now().toUtc(),
                text: _data['text'],
                author:
                    Provider.of<AuthProvider>(context, listen: false).userId,
              ));
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
                              'New Warning',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                _data["level"] = "INFO";
                              });
                            },
                            child: Text("INFO"),
                            color: _data["level"] == "INFO"
                                ? Colors.blue
                                : Colors.white,
                          ),
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                _data["level"] = "WARN";
                              });
                            },
                            child: Text("WARN"),
                            color: _data["level"] == "WARN"
                                ? Colors.yellow
                                : Colors.white,
                          ),
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                _data["level"] = "IMPORTANT";
                              });
                            },
                            child: Text("IMPORTANT"),
                            color: _data["level"] == "IMPORTANT"
                                ? Colors.red
                                : Colors.white,
                          ),
                        ],
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Text'),
                        initialValue: _data['text'],
                        maxLines: 2,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          return value.isNotEmpty
                              ? null
                              : "Please provide a text!";
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
