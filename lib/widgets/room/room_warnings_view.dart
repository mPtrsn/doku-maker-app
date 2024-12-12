import 'package:doku_maker/models/room/RoomWarning.dart';
import 'package:doku_maker/provider/auth_provider.dart';
import 'package:doku_maker/provider/room_provider.dart';
import 'package:doku_maker/screens/room/new_room_warning_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RoomWarningsView extends StatelessWidget {
  final List<RoomWarning> warnings;

  const RoomWarningsView(this.warnings);

  bool isOwner(BuildContext context) {
    return Provider.of<RoomProvider>(context, listen: false).isOwner(
        "roomId TODO",
        Provider.of<AuthProvider>(context, listen: false).userId);
  }

  void _openNewWarningDialog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => NewRoomWarningDialog(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, idx) => (idx == 0 && isOwner(context))
            ? Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ElevatedButton(
                  onPressed: () => _openNewWarningDialog(context),
                  child: Text("Create Warning"),
                  style: TextButton.styleFrom(
                      primary: Theme.of(context).accentColor),
                ),
              )
            : isOwner(context)
                ? AdminRoomWarningEntry(warnings[idx - 1])
                : RoomWarningEntry(warnings[idx]),
        itemCount: isOwner(context) ? warnings.length + 1 : warnings.length,
      ),
    );
  }
}

class RoomWarningEntry extends StatelessWidget {
  final RoomWarning warning;

  Widget get levelIcon {
    if (warning.level == 'INFO') {
      return Ink(
        decoration: ShapeDecoration(
          shape: CircleBorder(),
          color: Colors.blue,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Icon(Icons.warning),
        ),
      );
    }
    if (warning.level == 'WARN') {
      return Ink(
        decoration: ShapeDecoration(
          shape: CircleBorder(),
          color: Colors.amber,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Icon(Icons.warning),
        ),
      );
    }
    if (warning.level == 'IMPORTANT') {
      return Ink(
        decoration: ShapeDecoration(
          shape: CircleBorder(),
          color: Colors.red,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Icon(Icons.warning),
        ),
      );
    }
    return null;
  }

  const RoomWarningEntry(this.warning);

  String get dateString {
    String from = "";
    String to = "";
    String seperator = " - ";
    if (warning.validFrom == null) {
      from = "";
      seperator = "-> ";
    } else {
      from = DateFormat.MMMd().format(warning.validFrom);
    }
    if (warning.validTo == null) {
      to = "";
      seperator = "-> ";
    } else {
      to = DateFormat.MMMd().format(warning.validTo);
    }
    if (warning.validFrom == null && warning.validTo == null) {
      from = "";
      seperator = "";
      to = "valid";
    }
    return "$from$seperator$to";
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            levelIcon,
            SizedBox(width: 7),
            Flexible(
              child: Column(
                children: [
                  Text(dateString),
                  Text(
                    warning.text,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Divider(
        thickness: 2,
      ),
    ]);
  }
}

class AdminRoomWarningEntry extends RoomWarningEntry {
  AdminRoomWarningEntry(RoomWarning warning) : super(warning);

  Future<bool> enterEditMode(BuildContext context) async {
    return Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => NewRoomWarningDialog(warning),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(warning.id),
      background: Container(
        //margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: Theme.of(context).accentColor,
        child: Icon(Icons.edit, size: 40, color: Colors.white),
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: Container(
        //margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete, size: 40, color: Colors.white),
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (direction) {
        if (direction == DismissDirection.endToStart) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Remove this Warning?'),
              content: Text('Do you want to remove this warning?'),
              actions: [
                TextButton(
                    child: Text('Yes'),
                    onPressed: () async {
                      await Provider.of<RoomProvider>(context, listen: false)
                          .removeWarning("roomId", warning.id);
                      Navigator.of(context).pop(true);
                    }),
                TextButton(
                    child: Text('No'),
                    onPressed: () => Navigator.of(context).pop(false)),
              ],
            ),
          );
        } else {
          return enterEditMode(context);
        }
      },
      onDismissed: (direction) {},
      child: Column(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              levelIcon,
              SizedBox(width: 7),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dateString),
                    Text(
                      warning.text,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 2,
        ),
      ]),
    );
  }
}

/*
LEVELS: 
 - INFO: blue
 - WARN: yellow
 - IMPORTANT: red
*/
