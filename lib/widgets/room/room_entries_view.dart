import 'package:doku_maker/models/room/RoomEntry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../screens/room/new_room_entry_modal.dart';

class RoomEntriesView extends StatelessWidget {
  final List<RoomEntry> entries;

  const RoomEntriesView(this.entries);

  void _openAddEntryModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => NewRoomEntryModal());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, idx) => idx == 0
            ? RaisedButton(
                onPressed: () => _openAddEntryModal(context),
                child: Text("Add Entry"),
                color: Theme.of(context).accentColor,
              )
            : RoomEntriesEntry(entries[idx - 1]),
        itemCount: entries.length + 1,
      ),
    );
  }
}

class RoomEntriesEntry extends StatelessWidget {
  final RoomEntry entry;

  String get date {
    return DateFormat.MMMd().add_Hm().format(entry.creationDate);
  }

  const RoomEntriesEntry(this.entry);
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.author,
                style: TextStyle(fontSize: 12),
              ),
              Text(entry.title),
            ],
          ),
          Text(date),
        ],
      ),
      children: [
        ListTile(leading: Text(entry.text)),
        ListTile(
          leading: RaisedButton(
            child: Text("COUNT Attachments"),
            onPressed: () {
              /*
            TODO Step One: Carousel for images, carousel_slider 2.3.1
            */
            },
          ),
          trailing: RaisedButton(
            child: Text("Add Attachment"),
            onPressed: () {
              /*
            TODO Step One: Add image dialog
            */
            },
          ),
        ),
      ],
    );
  }
}
