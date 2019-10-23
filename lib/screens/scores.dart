import 'dart:convert';

import 'package:Risky_Biscuits/components/score-tile.dart';
import 'package:Risky_Biscuits/models/match.model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ScoresPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScoresPageState();
  }
}

class _ScoresPageState extends State<ScoresPage> {
  DateTime _dateToCheck;
  String _dateString = '';

  void decrementPressed() {
    setState(() {
      _dateToCheck = _dateToCheck.subtract(Duration(days: 7));
      _dateString = getDateString();
    });
  }

  void addPressed() {
    setState(() {
      _dateToCheck = _dateToCheck.add(Duration(days: 7));
      _dateString = getDateString();
    });
  }

  String getDateString() {
    return "${DateFormat('M/d').format(this._dateToCheck)} - ${DateFormat('M/d').format(this._dateToCheck.add(Duration(days: 7)))}";
  }

  @override
  void initState() {
    super.initState();
    _dateToCheck = DateTime.now();
    var diff = _dateToCheck.weekday - DateTime.sunday;
    if (diff < 0) {
      diff += 7;
    }
    var duration = Duration(days: diff);
    _dateToCheck = _dateToCheck.subtract(duration);
    _dateString = getDateString();
  }

  @override
  Widget build(BuildContext context) {
    var weekControl = Container(
        child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: IconButton(
                onPressed: decrementPressed,
                icon: Icon(Icons.chevron_left),
              ),
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: Text(_dateString),
              ),
            ),
            Expanded(
              flex: 2,
              child: IconButton(
                onPressed: addPressed,
                icon: Icon(Icons.chevron_right),
              ),
            )
          ],
        ),
        Divider(
          height: 10.0,
          color: Colors.grey,
        )
      ],
    ));

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
                child: Text('There are no matches this week'),
              );
            } else
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  MatchModel currentModel = snapshot.data[index];
                  return Padding(
                      padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 0.0),
                      child: ScoreTile(
                        team1Name: currentModel.challengerName,
                        team2Name: currentModel.oppositionName,
                        team1Score: currentModel.challengerScore,
                        team2Score: currentModel.oppositionScore,
                        matchDate: currentModel.matchDate,
                      ));
                },
              );
        }
      },
      future: _getMatches(),
    );
    return Column(
      children: <Widget>[weekControl, Expanded(child: matchList)],
    );
  }

  Future<List<MatchModel>> _getMatches() async {
    List<MatchModel> matches;
    var result = await http.get(
        "http://10.0.2.2:54732/api/match?datetocheck=${_dateToCheck.toString()}");
    if (result.statusCode == 200) {
      var data = json.decode(result.body) as List;
      matches = data.map<MatchModel>((j) => MatchModel.fromJson(j)).toList();
    }
    return matches;
  }
}
