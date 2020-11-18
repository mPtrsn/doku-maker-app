import 'package:doku_maker/exceptions/auth_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  String _token = '';

  String get userId {
    return 'testUser';
  }

  bool get isAuth {
    return _token.isNotEmpty;
  }

  Future<void> logIn(String username, String password) async {
    var url = 'https://fhwapp.fh-wedel.de/api/auth';
    var body = {"user": username, "pass": password};
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      var content = json.decode(response.body);
      _token = content['sessionToken'];
      // TODO save token in local storage
      notifyListeners();
    } else {
      throw AuthException(response.statusCode.toString(), 'Unable to Login!');
    }
  }

  Future tryLogin() {
    // TODO get called on splashscreen
    // TODO get token from local storage
  }
}
