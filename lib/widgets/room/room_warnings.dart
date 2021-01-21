import 'package:doku_maker/models/room/RoomWarning.dart';
import 'package:flutter/material.dart';

class RoomWarningsView extends StatelessWidget {
  final List<RoomWarning> warnings;

  const RoomWarningsView(this.warnings);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, idx) => RoomWarningEntry(warnings[idx]),
        itemCount: warnings.length,
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
          child: Icon(Icons.warning),
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
          child: Icon(Icons.warning),
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
          child: Icon(Icons.warning),
        ),
      );
    }
    return null;
  }

  const RoomWarningEntry(this.warning);
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
              child: Text(
                warning.text,
                style: TextStyle(
                  fontSize: 16,
                ),
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

/*
LEVELS: 
 - INFO: blue
 - WARN: yellow
 - IMPORTANT: red
*/
