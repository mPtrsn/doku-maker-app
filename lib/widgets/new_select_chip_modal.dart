import 'package:flutter/material.dart';

class NewSelectChipModal extends StatefulWidget {
  final String title;
  final Function(String newValue) onSave;
  final List<String> inputs;

  const NewSelectChipModal({this.title, this.onSave, this.inputs});

  @override
  _NewSelectChipModalState createState() => _NewSelectChipModalState();
}

class _NewSelectChipModalState extends State<NewSelectChipModal> {
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
