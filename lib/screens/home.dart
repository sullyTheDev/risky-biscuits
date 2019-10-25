import 'package:Risky_Biscuits/screens/matches.dart';
import 'package:Risky_Biscuits/screens/teams.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Risky_Biscuits/screens/leaderboard.dart';
import 'package:Risky_Biscuits/screens/scores.dart';
import 'package:Risky_Biscuits/screens/profile.dart';
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
     if (_selectedIndex != index) {
       setState(() {
      if (_selectedIndex != index) {
        _selectedIndex = index;
      }
    });
      }
  }

  Widget _showTab(int index) {
    switch (index) {
      case 0:
        return ScoresPage();
        break;
      case 1:
        return MatchPage();
        break;
      case 2:
        return LeaderboardPage();
        break;
      case 3:
        return TeamsPage();
      default:
        return ScoresPage();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> bottomNavItems = [
      BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/scoreboard.svg',
            width: 20.0,
            height: 20.0,
            color: _selectedIndex == 0 ? Colors.orange : Colors.black,
          ),
          title: Text('Scores')),
      BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/puck.svg',
            width: 20.0,
            height: 20.0,
            color: _selectedIndex == 1 ? Colors.orange : Colors.black,
          ),
          title: Text('Matches')),
      BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/leaderboard.svg',
            width: 20.0,
            height: 20.0,
            color: _selectedIndex == 2 ? Colors.orange : Colors.black,
          ),
          title: Text('Leaderboard')),
      BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/team.svg',
            width: 20.0,
            height: 20.0,
            color: _selectedIndex == 3 ? Colors.orange : Colors.black,
          ),
          title: Text('Teams'))
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavItems,
        backgroundColor: Colors.white,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black,
        unselectedLabelStyle: TextStyle(color: Colors.black),
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
      appBar: AppBar(
        title: bottomNavItems[_selectedIndex].title,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 5.0),
            child: IconButton(
              icon: Icon(Icons.perm_identity),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
            ),
          )
        ],
      ),
      body: _showTab(_selectedIndex),
    );
  }
}
