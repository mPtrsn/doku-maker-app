import 'package:doku_maker/models/room/RoomEntry.dart';
import 'package:doku_maker/models/room/RoomWarning.dart';
import 'package:doku_maker/provider/room_provider.dart';
import 'package:doku_maker/widgets/main_drawer.dart';
import 'package:doku_maker/widgets/room/room_entries_view.dart';
import 'package:doku_maker/widgets/room/room_warnings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class RoomDetailScreen extends StatelessWidget {
  static final String routeName = '/room-detail';

  Future<void> _getSmartarea(BuildContext context) async {
    await Provider.of<RoomProvider>(context, listen: false).getSmartarea();
  }

  void test(BuildContext ctx) {
    var room = Provider.of<RoomProvider>(ctx, listen: false).smartarea;
    room.warnings = new List<RoomWarning>();
    room.warnings.add(RoomWarning(level: "WARN", text: "Test Warnung"));
    room.warnings.add(RoomWarning(level: "INFO", text: "Test Info"));
    room.warnings.add(RoomWarning(level: "IMPORTANT", text: "Test Important"));

    room.entries = new List<RoomEntry>();
    room.entries.add(RoomEntry(
      title: 'First Entry',
      text: 'First Test',
      tags: ['Moin', 'Meister'],
      creationDate: DateTime.now().toUtc(),
    ));
    room.entries.add(RoomEntry(
      title: 'Second Entry',
      text: 'Second Test',
      tags: ['Moin', 'Meister'],
      creationDate: DateTime.now().toUtc(),
    ));
    room.entries.add(RoomEntry(
      title: 'Third Entry',
      text: 'Third Test',
      tags: ['Moin', 'Meister'],
      creationDate: DateTime.now().toUtc(),
    ));
    room.entries.add(RoomEntry(
      title: 'Fourth Entry',
      text: 'Fourth Test',
      tags: ['Moin', 'Meister'],
      creationDate: DateTime.now().toUtc(),
    ));
    room.entries.add(RoomEntry(
      title: 'Fifth Entry',
      text: 'Fifth Test',
      tags: ['Moin', 'Meister'],
      creationDate: DateTime.now().toUtc(),
    ));

    Provider.of<RoomProvider>(ctx, listen: false).performUpdate(room);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getSmartarea(context),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text('Smartarea'),
                      bottom: TabBar(
                        tabs: [
                          Tab(text: 'Warnings'),
                          Tab(text: 'Entries'),
                        ],
                      ),
                      actions: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          child: GestureDetector(
                            child: Icon(Icons.settings),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '',
                                arguments: null,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    drawer: MainDrawer(),
                    body: Consumer<RoomProvider>(
                      builder: (context, value, child) => Container(
                        margin: const EdgeInsets.all(10),
                        child: TabBarView(children: [
                          RoomWarningsView(value.smartarea.warnings),
                          RoomEntriesView(value.smartarea.entries),
                        ]),
                      ),
                    ),
                  ),
                ),
    );
  }
}
