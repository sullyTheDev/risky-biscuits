import 'dart:convert';

import 'package:Risky_Biscuits/models/team.model.dart';
import 'package:Risky_Biscuits/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/block_picker.dart';
import 'package:http/http.dart' as http;

class CreateTeamPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateTeamPageState();
  }
}

class CreateTeamPageState extends State<CreateTeamPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<UserModel> _users;
  UserModel _selectedUser;
  String _teamName;
  Color _teamColor;

  @override
  void initState() {
    super.initState();
    _teamColor = Colors.blue;
    _getUsers().then((res) {
      setState(() {
        _users = res;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(25),
      child: Center(
          child: Form(
        key: _formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              ),
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Team name is required';
                  }
                  return null;
                },
                onSaved: (input) => _teamName = input,
                decoration: InputDecoration(labelText: 'Team Name'),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              ),
              ListTile(
                onTap: _showColorPicker,
                title: Text('Choose Team color'),
                leading: CircleAvatar(
                  backgroundColor: _teamColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              ),
              DropdownButton(
                value: _selectedUser,
                items: _users?.map((u) => DropdownMenuItem(
                      value: u,
                      child: Text(u.name),
                    ))?.toList(),
                hint: Text('Choose a teammate'),
                onChanged: (user) {
                  setState(() {
                    print(user);
                    _selectedUser = user;
                  });
                },
              )
            ]),
      )),
    )));
  }

  Future<List<UserModel>> _getUsers() async {
    List<UserModel> users;
    var result = await http.get('http://10.0.2.2:54732/api/users');
    if (result.statusCode == 200) {
      var data = json.decode(result.body) as List;
      users = data.map<UserModel>((u) => UserModel.fromJson(u)).toList();
    }
    return users;
  }

  void _showColorPicker() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                child: Text('Choose Color'),
                onPressed: () {
                  setState(() {
                    _teamColor = _teamColor;
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
            content: BlockPicker(
                pickerColor: _teamColor,
                onColorChanged: (color) {
                  if (_teamColor != color) {
                    _teamColor = color;
                  }
                }),
          );
        });
  }
}
