import 'dart:convert';

import 'package:Risky_Biscuits/env.dart';
import 'package:Risky_Biscuits/models/match.model.dart';
import 'package:Risky_Biscuits/models/team.model.dart';
import 'package:Risky_Biscuits/models/user.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/block_picker.dart';
import 'package:http/http.dart' as http;

class CompleteMatch extends StatefulWidget {
  final MatchModel match;

  CompleteMatch({Key key, this.match}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return CompleteMatchState();
  }
}

class CompleteMatchState extends State<CompleteMatch> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  MatchModel _match;
  String challengerScore, opponentScore;

  @override
  void initState() {
    super.initState();
    _match = widget.match;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Manage Match'),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Card(child: Column(children: <Widget>[
                              ListTile(leading: CircleAvatar(
                                foregroundColor: Colors.white,
                                backgroundColor: Color(int.parse(this._match.challengerColor)),
                                child: Text(_avatarText(this._match.challengerName)),),
                                title: Text(this._match.challengerName),),
                              Padding(
                              padding: EdgeInsets.fromLTRB(25.0, 5.0, 150.0, 25.0),
                              child: TextFormField(
                                enabled: canComplete(),
                                keyboardType: TextInputType.number,
                                initialValue: challengerScore,
                                validator: (input) {
                                  if (input.isEmpty) {
                                    return 'A score is required';
                                  }
                                  if(int.parse(input) > 21) {
                                    return 'Score must be between 0 and 21';
                                  }
                                  return null;
                                },
                                onSaved: (input) => challengerScore = input,
                                decoration:
                                    InputDecoration(labelText: "Final Score"),
                              ),
                            )
                            ],),),
                            Padding(child: Text('VS', style: TextStyle(fontSize: 25),), padding: EdgeInsets.symmetric(vertical: 25.0),),
                            Card(child: Column(children: <Widget>[
                              ListTile(leading: CircleAvatar(
                                foregroundColor: Colors.white,
                                backgroundColor: Color(int.parse(this._match.oppositionColor)),
                                child: Text(_avatarText(this._match.oppositionName)),),
                                title: Text(this._match.oppositionName),),
                              Padding(
                              padding: EdgeInsets.fromLTRB(25.0, 5.0, 150.0, 25.0),
                              child: TextFormField(
                                enabled: canComplete(),
                                keyboardType: TextInputType.number,
                                initialValue: opponentScore,
                                validator: (input) {
                                  if (input.isEmpty) {
                                    return 'A score is required';
                                  }
                                  if(int.parse(input) > 21) {
                                    return 'Score must be between 0 and 21';
                                  }
                                  return null;
                                },
                                onSaved: (input) => opponentScore = input,
                                decoration:
                                    InputDecoration(labelText: "Final Score"),
                              ),
                            )
                            ],),),
                            Padding(padding: EdgeInsetsDirectional.only(top: 50.0), child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: canComplete() ? _completeMatch : null,
                    child: Text('Complete Match'),
                  ),
                ),),
                !canComplete() ?
               Padding(padding: EdgeInsets.only(top: 10.0), child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Padding(child: Icon(Icons.info_outline), padding: EdgeInsets.only(right: 10.0),),
                  Text('You can only complete a match after it starts.')
                ],),): Container(width: 0, height: 0,),
                          ],
                        ))))));
  }

  String _avatarText(String name) {
    String result = '';
    name = name.trim();
    var pieces = name.split(' ');

    pieces.forEach((p) {
      result = result + p.substring(0, 1).toUpperCase();
    });

    return result;
  }

  Future<void> _completeMatch() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();

      try {
        var bod = {};
        bod["challengerScore"] = challengerScore;
        bod["oppositionScore"] = opponentScore;
        var result = await http.put("${Env().baseUrl}/match/${_match.id}", headers: {
              "Accept": "application/json",
              "Content-Type": "application/json"
            },
            body: json.encode(bod));
        if(result.statusCode == 200) {
          Navigator.of(context).pop();
        }    
      } catch(e) {
        print(e);
      }
    }
  }

  bool canComplete(){
    return !DateTime.now().isBefore(this._match.matchDate);
  }
}
