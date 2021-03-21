import 'package:flutter/material.dart';

class NewEntryModalHeader extends StatelessWidget {
  final String title;
  final Function saveForm;

  const NewEntryModalHeader({Key key, this.title, this.saveForm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 26),
            textAlign: TextAlign.center,
          ),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: saveForm,
            child: Text('Save'),
            style: TextButton.styleFrom(primary: Theme.of(context).accentColor),
          ),
        ],
      ),
    );
  }
}
