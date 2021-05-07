import 'package:flutter/rendering.dart';
import 'dart:convert';

class User {
  String username;
  String lastname;
  String firstname;
  String email;
  String phone;
  String password;
  String api_key;
  String userID;

  User(this.userID, this.lastname, this.username, this.firstname, this.email,
      this.password, this.phone, this.api_key);

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
        parsedJson['userID'],
        parsedJson['LastName'],
        parsedJson['username'],
        parsedJson['FirstMidName'],
        parsedJson['email'],
        parsedJson['password'],
        parsedJson['phone'],
        parsedJson['api_key']);
  }
}
