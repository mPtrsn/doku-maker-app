import 'package:doku_maker/models/room/RoomWarning.dart';
import 'package:doku_maker/provider/auth_provider.dart';
import 'package:doku_maker/provider/room_provider.dart';
import 'package:doku_maker/widgets/adaptive/adaptive_progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  var _data = {
    'level': 'INFO',
    'text': '',
    "validFrom": DateTime.now(),
    "validTo": DateTime.now(),
  };
  var _isLoading = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.warning != null) {
        _data['level'] = widget.warning.level;
        _data['text'] = widget.warning.text;
        _data['validFrom'] = widget.warning.validFrom;
        _data['validTo'] = widget.warning.validTo;
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
                  validFrom: (_data["validFrom"] as DateTime).toUtc(),
                  validTo: (_data["validTo"] as DateTime).toUtc(),
                  text: _data['text']));
        } else {
          await Provider.of<RoomProvider>(context, listen: false).addWarning(
              widget.roomId,
              RoomWarning(
                id: null,
                level: _data['level'],
                creationDate: DateTime.now().toUtc(),
                validFrom: (_data["validFrom"] as DateTime).toUtc(),
                validTo: (_data["validTo"] as DateTime).toUtc(),
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

  Future _selectDate(BuildContext context, String dateField) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: _data[dateField],
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    setState(() {
      _data[dateField] = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
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
                                  'New Warning',
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
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _data["level"] = "INFO";
                              });
                            },
                            child: Text("INFO"),
                            style: _data["level"] == "INFO"
                                ? TextButton.styleFrom(
                                    backgroundColor: Colors.blue)
                                : TextButton.styleFrom(
                                    backgroundColor: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _data["level"] = "WARN";
                              });
                            },
                            child: Text("WARN"),
                            style: _data["level"] == "WARN"
                                ? TextButton.styleFrom(
                                    backgroundColor: Colors.yellow)
                                : TextButton.styleFrom(
                                    backgroundColor: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _data["level"] = "IMPORTANT";
                              });
                            },
                            child: Text("IMPORTANT"),
                            style: _data["level"] == "IMPORTANT"
                                ? TextButton.styleFrom(
                                    backgroundColor: Colors.red)
                                : TextButton.styleFrom(
                                    backgroundColor: Colors.white),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            DateFormat.MMMd().format(_data["validFrom"]),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _selectDate(context, "validFrom");
                            },
                            child: Text("Valid From"),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            DateFormat.MMMd().format(_data["validTo"]),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _selectDate(context, "validTo");
                            },
                            child: Text("Valid To"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
