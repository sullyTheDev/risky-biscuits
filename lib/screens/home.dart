import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/leaderboard.dart';
import 'package:first_app/screens/scores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  Home({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _showTab(int index) {
    switch (index) {
      case 0:
        return ScoresPage();
        break;
      case 1:
        return LeaderboardPage();
        break;
      case 2:
        return LeaderboardPage();
        break;  
      default:
        return ScoresPage();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: SvgPicture.asset('assets/scoreboard.svg', width: 20.0, height: 20.0,), title: Text('Scores')),
        BottomNavigationBarItem(icon: SvgPicture.asset('assets/puck.svg', width: 20.0, height: 20.0,), title: Text('Matches')),
        BottomNavigationBarItem(icon: SvgPicture.asset('assets/leaderboard.svg', width: 20.0, height: 20.0,), title: Text('Leaderboards')),
        BottomNavigationBarItem(icon: SvgPicture.asset('assets/team.svg', width: 20.0, height: 20.0,), title: Text('Teams')),
      ],
      backgroundColor: Colors.white,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.black,
      unselectedLabelStyle: TextStyle(color: Colors.black),
      type: BottomNavigationBarType.fixed,
      onTap: _onItemTapped,
      currentIndex: _selectedIndex,),
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[Icon(Icons.perm_identity)],
      ),
      body: _showTab(_selectedIndex),
    );
  }
}
