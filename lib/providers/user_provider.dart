import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:amazon_clone_tutorial/models/token_model.dart';

// import 'package:amazon_clone_tutorial/models/user.dart';

class UserProvider extends ChangeNotifier {
  UserToken _user = UserToken(
    id: '',
    name: '',
    username: '',
    password: '',
    address: '',
    status: '',
    access_token: '',
    token_type: '',
  );

  UserToken get user => _user;

  void setUser(String user) {
    // Map<String, dynamic> userData = jsonDecode(user);
    _user = UserToken.fromJson(user);
    notifyListeners();
  }
}
