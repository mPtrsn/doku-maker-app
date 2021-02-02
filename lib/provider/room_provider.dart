import 'dart:convert';

import 'package:doku_maker/config.dart';
import 'package:doku_maker/models/room/Room.dart';
import 'package:doku_maker/models/room/RoomEntry.dart';
import 'package:doku_maker/models/room/RoomWarning.dart';
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

  Map<String, String> get jsonUTF8Header {
    return {"Content-Type": "application/json; charset=utf-8"};
  }

  bool isOwner(String roomId, String username) {
    // ROOM UPDATE: use roomId
    return smartarea.owners.contains(username);
  }

  Future getSmartarea() async {
    http.Response response = await http.get(
      smartRoomUrl,
      headers: jsonUTF8Header,
    );
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
    http.Response response = await http.post(
      '$baseUrl/${room.id}',
      headers: jsonUTF8Header,
      body: jsonStr,
    );
    if (response.statusCode >= 400) {
      print('Perform Update Failed: ' + response.body);
      return null;
    }

    _smartarea =
        Room.fromJson(json.decode(response.body) as Map<String, dynamic>);
    notifyListeners();
  }

  Future deleteRoom(String id) async {
    print("TODO");
  }

  Future addWarning(String roomId, RoomWarning warning) async {
    // ROOM UPDATE: use roomId
    smartarea.warnings.add(warning);
    await performUpdate(smartarea);
    notifyListeners();
  }

  Future removeWarning(String roomId, String warningId) async {
    smartarea.warnings.removeWhere((e) => e.id == warningId);
    await performUpdate(smartarea);
    notifyListeners();
  }

  updateWarning(String roomId, RoomWarning roomWarning) async {
    // ROOM UPDATE: use roomId
    var indexWhere = smartarea.warnings
        .indexWhere((element) => element.id == roomWarning.id);
    smartarea.warnings[indexWhere] = roomWarning;
    await performUpdate(smartarea);
    notifyListeners();
  }
}
