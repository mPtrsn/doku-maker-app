import 'dart:convert';

import 'package:doku_maker/config.dart';
import 'package:doku_maker/models/room/Room.dart';
import 'package:doku_maker/models/room/RoomEntry.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class RoomProvider with ChangeNotifier {
  Room _smartarea;

  RoomProvider(this._smartarea);

  Room get smartarea {
    if (_smartarea != null) {
      _smartarea.entries.sort((RoomEntry a, RoomEntry b) =>
          a.creationDate.compareTo(b.creationDate));
    }
    return _smartarea;
  }

  String get baseUrl {
    return Config.backendURL + '/v1/rooms';
  }

  String get smartRoomUrl {
    return baseUrl + '/id/' + Config.smartareaID;
  }

  Future getSmartarea() async {
    http.Response response = await http.get(smartRoomUrl);
    if (response.statusCode >= 400) {
      print('Getting Smartarea Failed: ' + response.body);
      return null;
    }
    _smartarea =
        Room.fromJson(json.decode(response.body) as Map<String, dynamic>);
    notifyListeners();
  }

  Future addEntry(String roomId, RoomEntry entry) async {
    // ROOM UPDATE: use roomId
    smartarea.entries.add(entry);
    await performUpdate(smartarea);
    notifyListeners();
  }

  Future<void> removeEntry(String projectId, String id) async {
    // ROOM UPDATE: use roomId
    smartarea.entries.removeWhere((e) => e.id == id);
    await performUpdate(smartarea);
    notifyListeners();
  }

  Future performUpdate(Room room) async {
    String jsonStr = jsonEncode(room);
    print(jsonStr);
    http.Response response = await http.post('$baseUrl/${room.id}',
        headers: {"Content-Type": "application/json"}, body: jsonStr);
    if (response.statusCode >= 400) {
      print('Perform Update Failed: ' + response.body);
      return null;
    }

    _smartarea =
        Room.fromJson(json.decode(response.body) as Map<String, dynamic>);
    notifyListeners();
  }

  Future deleteProject(String id) async {
    print("TODO");
  }
}
