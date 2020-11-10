import 'package:doku_maker/models/entries/project_entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EntryElement extends StatelessWidget {
  const EntryElement({
    Key key,
    @required this.entry,
  }) : super(key: key);

  final ProjectEntry entry;

  String get title {
    return entry.title;
  }

  String get date {
    return DateFormat.MMMd().format(entry.creationDate);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(date),
        ],
      ),
      children: [entry.displayWidget],
    );
  }
}
