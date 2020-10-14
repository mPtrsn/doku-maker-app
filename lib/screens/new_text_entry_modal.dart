import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewTextEntryModal extends StatefulWidget {
  @override
  _NewTextEntryModalState createState() => _NewTextEntryModalState();
}

class _NewTextEntryModalState extends State<NewTextEntryModal> {
  final _titleController = TextEditingController();
  final _textController = TextEditingController();

  void _onSubmit() {}

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'title'),
              controller: _titleController,
              onSubmitted: (_) => _onSubmit(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'text'),
              controller: _textController,
              onSubmitted: (_) => _onSubmit(),
            ),
            CupertinoButton(
              onPressed: () {},
              child: Text('Save'),
              color: Theme.of(context).accentColor,
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('Save'),
              color: Theme.of(context).accentColor,
            ),
          ],
        ),
      ),
    );
  }
}
