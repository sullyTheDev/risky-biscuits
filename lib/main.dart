import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/home.dart';
import 'package:first_app/sign_in.dart';
import 'package:flutter/material.dart';

void main() => runApp(RiskyBiscuits());

class RiskyBiscuits extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
        primaryTextTheme: Typography(platform: TargetPlatform.android).white,
        primaryIconTheme: IconThemeData(color: Colors.white),
        accentIconTheme: IconThemeData(color: Colors.white),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: _handleCurrentScreen(),
    );
  }

  Widget _handleCurrentScreen() {
      return new StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              return Home(user: snapshot.data);
            } else {
              return SignInPage();
            }
        },
      );
    }
}