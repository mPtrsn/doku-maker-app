import 'dart:io';

import 'package:doku_maker/models/room/RoomEntry.dart';
import 'package:doku_maker/models/room/RoomEntryAttachment.dart';
import 'package:doku_maker/provider/room_provider.dart';
import 'package:doku_maker/provider/upload_service.dart';
import 'package:doku_maker/widgets/doku_image_picker.dart';
import 'package:doku_maker/widgets/room/room_attachment_element.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
            ? ElevatedButton(
                onPressed: () => _openAddEntryModal(context),
                child: Text("Add Entry"),
                style: TextButton.styleFrom(
                    primary: Theme.of(context).accentColor),
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

  void onImageSelected(File image, BuildContext context) async {
    var imageUrl = await UploadService.uploadImage("", image.path);
    RoomEntryAttachment attachment = RoomEntryAttachment(
      type: 'IMAGE',
      content: imageUrl,
    );
    Provider.of<RoomProvider>(context, listen: false)
        .updateEntry("roomID TODO", entry..attachments.add(attachment));
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
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: DokuImagePicker(
            onSelected: (image) => onImageSelected(image, context),
            showPreview: false,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: double.infinity,
            height: (entry.attachments.length / 2).round() * 150.0,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (ctx, idx) =>
                  RoomAttachmentElement(entry.attachments[idx], entry),
              itemCount: entry.attachments.length,
            ),
          ),
        ),
      ],
    );
  }
}
