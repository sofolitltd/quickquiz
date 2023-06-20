import 'package:flutter/material.dart';

import 'leaderboard/leaderboard_screen.dart';
import 'profile/profile_screen.dart';
import 'quiz/quiz_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNav(),
      body: screens.elementAt(_selectedIndex),
    );
  }

  //bottom nav
  BottomNavigationBar bottomNav() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Quiz',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.stacked_bar_chart_sharp),
          label: 'Ranking',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blueAccent.shade100,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}

List<Widget> screens = [
  const QuizScreen(),
  const LeaderboardScreen(),
  const ProfileScreen(),
];
