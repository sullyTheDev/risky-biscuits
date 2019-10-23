import 'dart:core';

class UserModel {
  int id;
  String name, email, authId;

  UserModel({this.id, this.name, this.email, this.authId});
  UserModel.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        email = data['email'],
        authId = data['authId'];
  Map toMap() {
    var map = new Map<String, String>();
    map['name'] = this.name;
    map['email'] = this.email;
    map['authId'] = this.authId;
    return map;
  }
}
