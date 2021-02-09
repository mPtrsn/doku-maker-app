import 'package:doku_maker/exceptions/auth_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token = '';

  String _username = '';

  String get userId {
    return _username;
  }

  bool get isAuth {
    return _token.isNotEmpty;
  }

  Future<void> logIn(String username, String password) async {
    var url = 'https://fhwapp.fh-wedel.de:4446/api/auth';
    var body = {"user": username, "pass": password};
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      var content = json.decode(response.body);
      _token = content['sessionToken'];
      _username = username;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('SESSION_TOKEN', _token);
      prefs.setString('USERNAME', username);
      notifyListeners();
    } else {
      throw AuthException(response.statusCode.toString(), 'Unable to Login!');
    }
  }

  Future tryLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('SESSION_TOKEN') &&
        prefs.getString('SESSION_TOKEN').isNotEmpty) {
      _token = prefs.getString('SESSION_TOKEN');
      _username = prefs.getString('USERNAME');
      notifyListeners();
    }
    return;
  }

  Future logout() async {
    final prefs = await SharedPreferences.getInstance();
    _token = '';
    _username = '';
    prefs.setString('SESSION_TOKEN', '');
    prefs.setString('USERNAME', '');
    notifyListeners();
  }
}
