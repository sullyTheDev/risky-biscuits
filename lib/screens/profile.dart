import 'dart:convert';

import 'package:Risky_Biscuits/models/user.model.dart';
import 'package:Risky_Biscuits/screens/sign_in.dart';
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
  String _existingPassword, _newPassword;
  bool changed = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _passKey = GlobalKey<FormFieldState>();
  var _newPassKey = GlobalKey<FormFieldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text('Profile'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: _user == null
                  ? CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 50.0, bottom: 20.0),
                          child: Icon(Icons.account_circle,
                              size: 150.0, color: Colors.grey),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, left: 30.0, right: 30.0),
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
                            padding: EdgeInsets.only(
                                top: 20.0, left: 30.0, right: 30.0),
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
                            padding: EdgeInsets.only(
                                top: 20.0, left: 30.0, right: 30.0),
                            child: TextFormField(
                              key: _passKey,
                              validator: (input) {
                                var newPass = _newPassKey.currentState.value;
                                if (input.isEmpty && newPass.isNotEmpty)
                                  return 'Existing password is required';
                                if (input.isNotEmpty &&
                                    input.length < 8 &&
                                    newPass.isNotEmpty)
                                  return 'Password must be at least 8 characters long.';
                                return null;
                              },
                              onSaved: (input) => _existingPassword = input,
                              decoration: InputDecoration(
                                  labelText: 'Existing Password'),
                              obscureText: true,
                              onChanged: (input) {
                                setState(() {
                                  changed = input.isNotEmpty ? true : false;
                                });
                              },
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                top: 20.0, left: 30.0, right: 30.0),
                            child: TextFormField(
                              key: _newPassKey,
                              validator: (input) {
                                var existingPass = _passKey.currentState.value;
                                if (input.isEmpty && existingPass.isNotEmpty)
                                  return 'A new password is required';
                                if (input.isNotEmpty &&
                                    input.length < 8 &&
                                    existingPass.isNotEmpty)
                                  return 'Password must be at least 8 characters long.';
                                return null;
                              },
                              onSaved: (input) => _newPassword = input,
                              decoration:
                                  InputDecoration(labelText: 'New Password'),
                              obscureText: true,
                              onChanged: (input) {
                                setState(() {
                                  changed = input.isNotEmpty ? true : false;
                                });
                              },
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 30.0, right: 30.0, top: 30.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: RaisedButton(
                                color: Colors.blue,
                                textColor: Colors.white,
                                onPressed:
                                    changed == false ? null : _updateUser,
                                child: Text('Save'),
                              ),
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 30.0, right: 30.0, top: 10.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: RaisedButton(
                                color: Colors.blue,
                                textColor: Colors.white,
                                onPressed: _logOut,
                                child: Text('Log out'),
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
    bool updatePWSuccess, updateUserSuccess = false;
    if (formState.validate()) {
      formState.save();
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      if (_existingPassword != null && _newPassword != null) {
        try {
          updatePWSuccess = true;
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: user.email, password: _existingPassword);
          await user
              .updatePassword(_newPassword);
        } catch (e) {
          updatePWSuccess = false;
          print(e.message);
           _errorAlert();
        }
      } else
        updatePWSuccess = true;
      try {
        var userModel =
            UserModel(name: _user.name, email: _user.email, authId: user.uid)
                .toMap();
        var result = await http
            .put('http://10.0.2.2:54732/api/users/${user.uid}',
                headers: {
                  "Accept": "application/json",
                  "Content-Type": "application/json"
                },
                body: json.encode(userModel));
          updateUserSuccess = result.statusCode == 200;      
      } catch (e) {
        updateUserSuccess = false;
        print(e.message);
        _errorAlert();
      }
      if (updatePWSuccess && updateUserSuccess) {
        setState(() {
         changed = false; 
        }); 
      }
      updatePWSuccess = false;
      updateUserSuccess = false;
    }
  }

  void _logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }

  void _showSuccessSnackbar() {
    final snackBar = SnackBar(content: Text('Save Successful'));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _errorAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(children: <Widget>[
            new Center(
                child: new Container(
                    child:
                        new Text('We had a problem with your request :(')))
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
