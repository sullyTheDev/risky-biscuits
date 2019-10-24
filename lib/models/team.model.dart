import 'dart:core';

import 'package:Risky_Biscuits/models/user.model.dart';

class TeamModel {
  int id;
  String name, color;
  List<UserModel> users;

  TeamModel({this.id, this.name, this.color, this.users});
  TeamModel.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        color = data['color'],
        users = (data['users'] as List).map((u) => UserModel.fromJson(u)).toList();
}
