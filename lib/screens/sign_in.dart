import 'package:first_app/screens/sign_up.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInPageState();
  }
}

class _SignInPageState extends State<SignInPage> {
  String _email, _password;
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
                    onPressed: _signIn,
                    child: Text('Sign In'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                ),
                Divider(),
                Text('Don\'t have an account?', textAlign: TextAlign.center),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Click ',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.body1.color)),
                    TextSpan(
                        text: 'here ',
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage(),
                                  fullscreenDialog: true))),
                    TextSpan(
                        text: 'to get Shufflin\'',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.body1.color)),
                  ]),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }

  Future<void> _signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
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
