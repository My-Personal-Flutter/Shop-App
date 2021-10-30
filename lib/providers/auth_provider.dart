import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  DateTime? _expiryDataTime;
  String? _userId;

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
      notifyListeners();
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
}
