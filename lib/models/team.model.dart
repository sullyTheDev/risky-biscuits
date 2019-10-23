import 'dart:core';

class TeamModel {
  int id;
  String name;

  TeamModel({this.id, this.name});
  TeamModel.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'];
}
