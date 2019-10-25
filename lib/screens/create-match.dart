import 'dart:convert';

import 'package:Risky_Biscuits/models/team.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Risky_Biscuits/models/match.model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../env.dart';

class CreateMatchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateMatchPageState();
  }
}

class _CreateMatchPageState extends State<CreateMatchPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _selectedTeam, _selectedOpponent;
  List<TeamModel> opponents = [];
  List<TeamModel> userTeams = [];
  DateTime _fromDate;
  TimeOfDay _fromTime;
  @override
  void initState() {
    super.initState();
    this._getOpponents();
    this._getUserTeams();
    _fromDate = DateTime.now().add(Duration(minutes: 5));
    _fromTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Match')),
      body: new Form(
          key: _formKey,
          child: new ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: new FormField(
                  builder: (FormFieldState state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Your Team',
                      ),
                      isEmpty: userTeams.length == 0,
                      child: new DropdownButtonHideUnderline(
                        child: new DropdownButton(
                          items: userTeams.map((item) {
                            return new DropdownMenuItem(
                              child: new Text(item.name),
                              value: item.id.toString(),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              _selectedTeam = newVal;
                            });
                          },
                          value: _selectedTeam,
                        ),
                      ),
                    );
                  },
                ),
              ),
              new FormField(
                builder: (FormFieldState state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Opponent',
                    ),
                    isEmpty: opponents.length == 0,
                    child: new DropdownButtonHideUnderline(
                      child: new DropdownButton(
                        items: opponents.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(item.name),
                            value: item.id.toString(),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            _selectedOpponent = newVal;
                          });
                        },
                        value: _selectedOpponent,
                      ),
                    ),
                  );
                },
              ),
              new FormField(
                builder: (FormFieldState state) {
                  return Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: _DateTimePicker(
                        labelText: 'Match Date',
                        selectedDate: _fromDate,
                        selectedTime: _fromTime,
                        selectDate: (DateTime date) {
                          setState(() {
                            _fromDate = date;
                            print(_fromDate);
                          });
                        },
                        selectTime: (TimeOfDay time) {
                          setState(() {
                            _fromTime = time;
                            print(_fromTime);
                          });
                        },
                      ));
                },
              ),
              new Container(
                  padding: EdgeInsets.only(top: 40, left: 20, right: 20),
                  child: new RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: const Text('Submit'),
                    onPressed:
                        _selectedOpponent != null && _selectedTeam != null
                            ? () {
                                _createMatch();
                              }
                            : null,
                  )),
            ],
          )),
    );
  }

  Future<List<TeamModel>> _getOpponents() async {
    List<TeamModel> results;
    var result = await http.get('${Env().baseUrl}/teams');
    if (result.statusCode == 200) {
      // print(result.body);
      var data = json.decode(result.body) as List;
      results = data.map<TeamModel>((j) => TeamModel.fromJson(j)).toList();

      setState(() {
        opponents = results;
      });
    }
    return results;
  }

  Future<List<TeamModel>> _getUserTeams() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    List<TeamModel> results;
    var result =
        await http.get('${Env().baseUrl}/teams?authId=${user.uid}');
    if (result.statusCode == 200) {
      // print(result.body);
      var data = json.decode(result.body) as List;
      results = data.map<TeamModel>((j) => TeamModel.fromJson(j)).toList();

      setState(() {
        userTeams = results;
      });
    }
    return results;
  }

  Future<void> _createMatch() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        var matchModel = MatchModel(
                oppositionId: int.parse(_selectedOpponent),
                challengerId: int.parse(_selectedTeam),
                matchDate: new DateTime(_fromDate.year, _fromDate.month,
                    _fromDate.day, _fromTime.hour, _fromTime.minute),
                rulesetId: 1)
            .toMap();
        var result = await http.post('${Env().baseUrl}/match',
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json"
            },
            body: json.encode(matchModel));
        print(result);
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
      }
    }
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    Key key,
    this.child,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed,
  }) : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade700
                  : Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}

class _DateTimePicker extends StatefulWidget {
  const _DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectedTime,
    this.selectDate,
    this.selectTime,
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  @override
  __DateTimePickerState createState() => __DateTimePickerState();
}

class __DateTimePickerState extends State<_DateTimePicker> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate:
          widget.selectedDate.subtract(Duration(hours: DateTime.now().hour)),
      lastDate: DateTime(2101),
    );
    if (picked != null) widget.selectDate(picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: widget.selectedTime,
    );
    if (picked != null) widget.selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: _InputDropdown(
            labelText: widget.labelText,
            valueText: DateFormat.yMMMd().format(widget.selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          flex: 3,
          child: _InputDropdown(
            valueText: widget.selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () {
              _selectTime(context);
            },
          ),
        ),
      ],
    );
  }
}
