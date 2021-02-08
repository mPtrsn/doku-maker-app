import 'package:flutter/material.dart';

class NewChipModal extends StatefulWidget {
  final String title;
  final Function(String newValue) onSave;
  const NewChipModal({this.title, this.onSave});

  @override
  _NewChipModalState createState() => _NewChipModalState();
}

class _NewChipModalState extends State<NewChipModal> {
  final _form = GlobalKey<FormState>();
  String newChip = '';

  Future _saveForm() async {
    _form.currentState.save();
    if (newChip.isNotEmpty) {
      widget.onSave(newChip);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Form(
              key: _form,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(fontSize: 26),
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                        onPressed: _saveForm,
                        child: Text('Add'),
                        style: TextButton.styleFrom(
                            primary: Theme.of(context).accentColor),
                      ),
                    ],
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'New Entry'),
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      return null;
                    },
                    onSaved: (newValue) {
                      newChip = newValue;
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
