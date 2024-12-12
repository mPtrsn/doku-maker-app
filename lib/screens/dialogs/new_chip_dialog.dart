import 'package:flutter/material.dart';

class NewChipDialog extends StatefulWidget {
  final String title;
  final Function(String newValue) onSave;
  const NewChipDialog({this.title, this.onSave});

  @override
  _NewChipDialogState createState() => _NewChipDialogState();
}

class _NewChipDialogState extends State<NewChipDialog> {
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
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveForm,
            )
          ],
        ),
        body: Container(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: _form,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'New Entry'),
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      return null;
                    },
                    onSaved: (newValue) {
                      newChip = newValue;
                    },
                    onFieldSubmitted: (_) => _saveForm(),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
