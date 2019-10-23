import 'dart:convert';

import 'package:Risky_Biscuits/models/team.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Risky_Biscuits/models/match.model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CreateMatchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateMatchPageState();
  }
}

class _CreateMatchPageState extends State<CreateMatchPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _mySelection = null;
  List<TeamModel> teams = [];
  DateTime _fromDate = DateTime.now();
  TimeOfDay _fromTime = const TimeOfDay(hour: 7, minute: 28);
  DateTime _toDate = DateTime.now();
  TimeOfDay _toTime = const TimeOfDay(hour: 7, minute: 28);
  @override
  void initState() {
    super.initState();
    this._getMatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Match')),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new FormField(
                    builder: (FormFieldState state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Opponent',
                        ),
                        isEmpty: teams.length == 0,
                        child: new DropdownButtonHideUnderline(
                          child: new DropdownButton(
                            items: teams.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(item.name),
                                value: item.id.toString(),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                _mySelection = newVal;
                              });
                            },
                            value: _mySelection,
                          ),
                        ),
                      );
                    },
                  ),
                  new FormField(
                    builder: (FormFieldState state) {
                      return _DateTimePicker(
                        labelText: 'From',
                        selectedDate: _fromDate,
                        selectedTime: _fromTime,
                        selectDate: (DateTime date) {
                          setState(() {
                            _fromDate = date;
                          });
                        },
                        selectTime: (TimeOfDay time) {
                          setState(() {
                            _fromTime = time;
                          });
                        },
                      );
                    },
                  ),
                  new Container(
                      child: new RaisedButton(
                    child: const Text('Submit'),
                    onPressed: () {
                      _createMatch();
                    },
                  )),
                ],
              ))),
    );
  }

  Future<List<TeamModel>> _getMatches() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    List<TeamModel> results;
    var result =
        await http.get('http://10.0.2.2:54732/api/teams?authId=${user.uid}');
    if (result.statusCode == 200) {
      print(result.body);
      var data = json.decode(result.body) as List;
      results = data.map<TeamModel>((j) => TeamModel.fromJson(j)).toList();

      setState(() {
        teams = results;
      });
    }
    return results;
  }

  Future<void> _createMatch() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        var matchModel = MatchModel(
            oppositionId: int.parse(_mySelection),
            challengerId: 1,
            matchDate: new DateTime.now());
        await http.post('http://10.0.2.2:54732/api/match',
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json"
            },
            body: json.encode(matchModel));
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
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != widget.selectedDate)
      widget.selectDate(picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: widget.selectedTime,
    );
    if (picked != null && picked != widget.selectedTime)
      widget.selectTime(picked);
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
