import 'dart:convert';

import 'package:Risky_Biscuits/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../env.dart';
import './home.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpPageState();
  }
}

class _SignUpPageState extends State<SignUpPage> {
  String _name, _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                Image.asset('assets/risky_bs_small.png'),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                ),
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Name is required.';
                    }
                    return null;
                  },
                  onSaved: (input) => _name = input,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                ),
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'An email is required.';
                    }
                    return null;
                  },
                  onSaved: (input) => _email = input,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                ),
                TextFormField(
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
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: _signUp,
                    child: Text('Get Shufflin\''),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Future<void> _signUp() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        var userModel =
            UserModel(name: _name, email: _email, authId: user.uid).toMap();
        await http.post('${Env().baseUrl}/users',
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json"
            },
            body: json.encode(userModel));
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                      user: user,
                    )));
      } catch (e) {
        print(e.message);
      }
    }
  }
}
