import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  DateTime? _expiryDataTime;
  String? _userId;
  Timer? _authTimer;
  bool get isAuthenticated {
    return token != null;
  }

  String? get token {
    if (_expiryDataTime != null &&
        _token != null &&
        _expiryDataTime!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    const API_KEY = "AIzaSyBKL8qIu8lmFyfAwcajWgidIa66uWzUN9Q";
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$API_KEY");
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );
      print(json.decode(response.body));
      final result = json.decode(response.body);

      if (result['error'] != null) {
        throw HttpException(result["error"]['message']);
      }
      _token = result["idToken"];
      _userId = result["localId"];
      _expiryDataTime = DateTime.now().add(
        Duration(
          seconds: int.parse(
            result["expiresIn"],
          ),
        ),
      );
      _autoLogoutTimer();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          "token": _token,
          "userId": _userId,
          "expiryDateTime": _expiryDataTime!.toIso8601String(),
        },
      );
      prefs.setString("userData", userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey("userData")) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString("userData")!) as Map<String, Object>;

    final expiryDateTime =
        DateTime.parse(extractedUserData["expiryDateTime"] as String);

    if (expiryDateTime.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData["token"] as String;
    _userId = extractedUserData["userId"] as String;
    _expiryDataTime = expiryDateTime;

    notifyListeners();
    _autoLogoutTimer();

    return true;
  }

  Future<void> logout() async {
    _token = null;
    _expiryDataTime = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userData");
  }

  void _autoLogoutTimer() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDataTime!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
