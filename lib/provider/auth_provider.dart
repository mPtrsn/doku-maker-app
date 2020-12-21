import 'package:doku_maker/exceptions/auth_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token = '';

  String _username = '';

  String get userId {
    return 'stec102359';
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
    if (prefs.containsKey('SESSION_TOKEN')) {
      _token = prefs.getString('SESSION_TOKEN');
      _username = prefs.getString('USERNAME');
    }
    notifyListeners();
  }

  Future logout() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('SESSION_TOKEN')) {
      _token = prefs.getString('SESSION_TOKEN');
    }
    notifyListeners();
  }
}
