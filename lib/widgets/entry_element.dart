import 'package:doku_maker/models/entries/project_entry.dart';
import 'package:doku_maker/provider/projects_provider.dart';
import 'package:doku_maker/screens/new_text_entry_modal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EntryElement extends StatefulWidget {
  const EntryElement({
    Key key,
    @required this.entry,
    @required this.projectId,
  }) : super(key: key);

  final String projectId;
  final ProjectEntry entry;

  @override
  _EntryElementState createState() => _EntryElementState();
}

class _EntryElementState extends State<EntryElement> {
  String get title {
    return widget.entry.title;
  }

  String get date {
    return DateFormat.MMMd().add_Hm().format(widget.entry.creationDate);
  }

  Future<bool> enterEditMode() async {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => NewTextEntryModal(widget.projectId));
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.entry.id),
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: Theme.of(context).accentColor,
        child: Icon(Icons.edit, size: 40, color: Colors.white),
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete, size: 40, color: Colors.white),
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (direction) {
        if (direction == DismissDirection.endToStart) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Remove this Entry?'),
              content:
                  Text('Do you want to remove this entry from your project?'),
              actions: [
                FlatButton(
                    child: Text('Yes'),
                    onPressed: () async {
                      await Provider.of<ProjectsProvider>(context,
                              listen: false)
                          .removeEntry(widget.projectId, widget.entry.id);
                      Navigator.of(context).pop(true);
                    }),
                FlatButton(
                    child: Text('No'),
                    onPressed: () => Navigator.of(context).pop(false)),
              ],
            ),
          );
        } else {
          return enterEditMode();
        }
      },
      onDismissed: (direction) {},
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(date),
          ],
        ),
        children: [widget.entry.displayWidget],
      ),
    );
  }
}
