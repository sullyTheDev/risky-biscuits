import 'dart:convert';

import 'package:Risky_Biscuits/models/user.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  // Profile({Key key, this.user}) : super(key: key);
  // final FirebaseUser user;

  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  UserModel _user;
  String _password;
  bool changed = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Center(child: new Text('Loading...'));
    }
    return Scaffold(
        appBar: AppBar(
          title: new Text('Profile'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 80.0, bottom: 20.0),
                    child: Icon(Icons.account_circle,
                        size: 150.0, color: Colors.grey),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                    child: TextFormField(
                      initialValue: _user.name,
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Name is required.';
                        }
                        return null;
                      },
                      onSaved: (input) => _user.name = input,
                      decoration: InputDecoration(labelText: 'Name'),
                      onChanged: (input) {
                        setState(() {
                          if (_user.name != input)
                            changed = true;
                          else
                            changed = false;
                        });
                      },
                    ),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                      child: TextFormField(
                        initialValue: _user.email,
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'An email is required.';
                          }
                          return null;
                        },
                        onSaved: (input) => _user.email = input,
                        decoration: InputDecoration(labelText: 'Email'),
                        onChanged: (input) {
                          setState(() {
                            if (_user.email != input)
                              changed = true;
                            else
                              changed = false;
                          });
                        },
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                      child: TextFormField(
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'A password is required.';
                          } else if (input.length < 8) {
                            return 'Password must be at least 8 characters long.';
                          }
                          return null;
                        },
                        onSaved: (input) => _password = input,
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        onChanged: (input) {
                          setState(() {
                            if (input.isNotEmpty)
                              changed = true;
                            else
                              changed = false;
                          });
                        },
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 30.0, right: 30.0, top: 40.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: changed == false ? null : _updateUser,
                          child: Text('Save'),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    _getUser().then((x) {
      setState(() {
        _user = x;
      });
    });
  }

  Future<UserModel> _getUser() async {
    FirebaseUser fbUser = await FirebaseAuth.instance.currentUser();
    UserModel userData;
    var result =
        await http.get('http://10.0.2.2:54732/api/users/${fbUser.uid}');
    if (result.statusCode == 200) {
      var data = json.decode(result.body);
      userData = UserModel.fromJson(data);
    } else {
      userData = new UserModel(name: '', email: '');
      _errorAlert();
    }
    return userData;
  }

  Future<void> _updateUser() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      if (_password != null) {
        try {
          FirebaseUser user = await FirebaseAuth.instance.currentUser();
          await user.updatePassword(_password);
        } catch (e) {
          print(e.message);
        }
      }
      // TODO update user on shuffle api
      // await http.put(url)
    }
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
