import 'dart:convert';

import 'package:Risky_Biscuits/components/score-tile.dart';
import 'package:Risky_Biscuits/models/match.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

class CreateMatchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateMatchPageState();
  }
}

class _CreateMatchPageState extends State<CreateMatchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Match')),
      body: Center(
        child: IconButton(
          icon: Icon(Icons.save),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Home(
                          user: null,
                        )));
          },
        ),
      ),
    );
  }
}
