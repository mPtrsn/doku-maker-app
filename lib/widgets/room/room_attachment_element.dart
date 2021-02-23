import 'package:doku_maker/models/room/RoomEntry.dart';
import 'package:doku_maker/models/room/RoomEntryAttachment.dart';
import 'package:doku_maker/provider/room_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config.dart';

class RoomAttachmentElement extends StatelessWidget {
  final RoomEntry entry;
  final RoomEntryAttachment attachment;

  const RoomAttachmentElement(this.attachment, this.entry);

  onDelete(BuildContext context) async {
    await Provider.of<RoomProvider>(context, listen: false)
        .updateEntry("roomId", entry..attachments.remove(attachment));
  }

  Widget child(BuildContext context) {
    switch (attachment.type) {
      case 'IMAGE':
        return GestureDetector(
          child: Image.network(
            Config.couchdbURL + attachment.content,
            fit: BoxFit.cover,
          ),
          onTap: () async {
            await showDialog(
              context: context,
              builder: (_) => ImageDialog(
                url: Config.couchdbURL + attachment.content,
                onDelete: () => onDelete(context),
              ),
            );
          },
        );
      case 'LINK':
        return Text(attachment.content);
      default:
        return Text("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: child(context),
    );
  }
}

class ImageDialog extends StatelessWidget {
  final String url;
  final Function onDelete;

  const ImageDialog({Key key, @required this.url, this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.3),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(url,
                      headers: {'Authorization': 'Basic cmVhZGVyOnJlYWRlcg=='}),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Remove this Image?'),
                        content: Text('Do you want to remove this image?'),
                        actions: [
                          TextButton(
                              child: Text('Yes'),
                              onPressed: () async {
                                onDelete();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              }),
                          TextButton(
                            child: Text('No'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.delete),
                  label: Text('Delete'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close),
                  label: Text('Close'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
