import 'dart:convert';

import 'package:Risky_Biscuits/models/team.model.dart';
import 'package:Risky_Biscuits/models/user.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/block_picker.dart';
import 'package:http/http.dart' as http;

import '../env.dart';

class CreateTeamPage extends StatefulWidget {
  final TeamModel team;

  CreateTeamPage({Key key, this.team}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return CreateTeamPageState();
  }
}

class CreateTeamPageState extends State<CreateTeamPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TeamModel _team;
  List<UserModel> _users;
  UserModel _selectedUser;
  UserModel _selectedReadonlyUser;
  String _teamName;
  Color _teamColor;

  @override
  void initState() {
    super.initState();
    _team = widget.team;

    if (_team != null) {
      _teamColor = Color(int.parse(_team.color));
      _teamName = _team.name;
      _selectedReadonlyUser = _team.users[1];
    } else {
      _teamColor = Colors.blue;
    }

    _getUsers().then((res) {
      setState(() {
        _users = res;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _team == null ? Text('Create Team'): Text(_team.name),
        ),
        body: SingleChildScrollView(
            child: Container(
          height: MediaQuery.of(context).size.height - 100,
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
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Icon(Icons.people, size: 150.0, color: Colors.grey),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: TextFormField(
                      enabled: _team == null,
                      initialValue: _teamName,
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Team name is required';
                        }
                        return null;
                      },
                      onSaved: (input) => _teamName = input,
                      decoration: InputDecoration(labelText: 'Team Name'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: ListTile(
                      onTap: _team == null ? _showColorPicker : null,
                      title: Text('Team color'),
                      leading: CircleAvatar(
                        backgroundColor: _teamColor,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  _team == null
                      ? Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                            value: _selectedUser,
                            items: _users
                                ?.map((u) => DropdownMenuItem(
                                      value: u,
                                      child: Text(u.name),
                                    ))
                                ?.toList(),
                            hint: Text('Choose a teammate'),
                            onChanged: (user) {
                              setState(() {
                                print(user);
                                _selectedUser = user;
                              });
                            },
                          )),
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            enabled: _team == null,
                            initialValue: _selectedReadonlyUser.name,
                            decoration: InputDecoration(labelText: 'Teammate'),
                          ),
                        ),
                  _team == null
                      ? Column(
                          children: <Widget>[
                            Divider(
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: RaisedButton(
                                color: Colors.blue,
                                textColor: Colors.white,
                                onPressed: _createTeam,
                                child: Text('Create Team'),
                              ),
                            )
                          ],
                        )
                      : Container(
                          width: 0.0,
                          height: 0.0,
                        ),
                ]),
          )),
        )));
  }

  Future<List<UserModel>> _getUsers() async {
    List<UserModel> users;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var result =
        await http.get("${Env().baseUrl}/users?authId=${user.uid}");
    if (result.statusCode == 200) {
      var data = json.decode(result.body) as List;
      users = data.map<UserModel>((u) => UserModel.fromJson(u)).toList();
    }
    return users;
  }

  Future<void> _createTeam() async {
    final formState = _formKey.currentState;
    if (formState.validate() && _selectedUser != null && _teamColor != null) {
      formState.save();
      TeamModel team = TeamModel(
          color: _teamColor.value.toString(),
          name: _teamName,
          users: [_selectedUser].toList());
      try {
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        var result = await http.post(
            "${Env().baseUrl}/teams?authId=${user.uid}",
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json"
            },
            body: json.encode(team.toMap()));

            Navigator.of(context).pop();
        print(result.body);
      } catch (e) {
        print(e);
      }
    }
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
