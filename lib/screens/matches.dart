import 'dart:convert';

import 'package:Risky_Biscuits/components/score-tile.dart';
import 'package:Risky_Biscuits/components/slide-right-nav.dart';
import 'package:Risky_Biscuits/models/match.model.dart';
import 'package:Risky_Biscuits/screens/complete-match.dart';
import 'package:Risky_Biscuits/screens/create-match.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;

import '../env.dart';

class MatchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MatchPageState();
  }
}

class _MatchPageState extends State<MatchPage> {
  @override
  Widget build(BuildContext context) {
    var matchList = FutureBuilder(
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else if (snapshot.data.length == 0) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                  Text("You don't have any upcoming matches..."),
                  Padding(padding: EdgeInsets.only(top: 5.0),
                  child: Icon(Icons.sentiment_dissatisfied),)
                ],)
                  
              );
            } else
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  MatchModel currentModel = snapshot.data[index];
                  return Slidable(
                    secondaryActions: <Widget>[
                      IconSlideAction(
              caption: 'Cancel Match',
              color: Colors.red,
              iconWidget: Padding(padding: EdgeInsets.only(bottom: 5), child: Icon(Icons.cancel, color: Colors.white,),),
              onTap: () {
                _cancelMatch(currentModel.id);
              },
            ),
                    ],
                    actionPane: SlidableDrawerActionPane(),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 0.0),
                      child: ScoreTile(match: currentModel, onTap: () {Navigator.push(context, SlideRightRoute(page: CompleteMatch(match: currentModel,)));},)),);
                },
              );
        }
      },
      future: _getMatches(),
    );

    return Scaffold(body: matchList, floatingActionButton: FloatingActionButton( onPressed: _createMatchPage, child: Icon(Icons.add),),);
  }

  Future<List<MatchModel>> _getMatches() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    List<MatchModel> results;
    var result = await http
        .get("${Env().baseUrl}/match?future=true&authId=${user.uid}");
    if (result.statusCode == 200) {
      print(result.body);
      var data = json.decode(result.body) as List;
      results = data.map<MatchModel>((j) => MatchModel.fromJson(j)).toList();
    }
    return results;
  }

  Future<void> _cancelMatch(int id) async {
    var result = await http
        .put("${Env().baseUrl}/match/$id/cancel", headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode(false) );

        if (result.statusCode == 200) {
          setState(() {
            
          });
        }
  }

  void _createMatchPage() {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateMatchPage()));
  }
}
