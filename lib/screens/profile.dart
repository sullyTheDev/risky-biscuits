import 'dart:convert';

import 'package:Risky_Biscuits/models/user.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  Profile({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            UserModel currentUser = snapshot.data[0];
            return Scaffold(
              appBar: AppBar(title: new Text(currentUser.name)),
            );
        }
      },
      future: _getUser(),
    );
  }

  Future<UserModel> _getUser() async {
    FirebaseUser fbUser = await FirebaseAuth.instance.currentUser();
    UserModel userData;
    try {
      var result = await http.get('http://10.0.2.2:54732/api/users/${fbUser.uid}');
      if (result.statusCode == 200) {
        var data = json.decode(result.body);
        userData = data.map<UserModel>((x) => UserModel.fromJson(x));
      }
    } catch (e) {
      print(e.message);
      _errorAlert();
    }
    return userData;
  }

  void _errorAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(children: <Widget>[
            new Center(
                child: new Container(
                    child:
                        new Text('We had trouble retreiving your profile :(')))
          ]);
        });
  }

  void _saveDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Unsaved changes'),
            content: new Text(
                'Are you sure you want to exit? There are unsaved changes on your profile.'),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Accept'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
