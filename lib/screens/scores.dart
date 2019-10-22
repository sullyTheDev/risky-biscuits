import 'package:first_app/screens/sign_up.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';

class ScoresPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScoresPageState();
  }
}

class _ScoresPageState extends State<ScoresPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        SingleChildScrollView(
          child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(25),
          child: Center(
            child: Text('test'),
        )),
        )); 
        
  }

  Future<void> _signIn() async{
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(user: user,)));
      }catch(e) {
        print(e.message);
      }
    }
  }
}
