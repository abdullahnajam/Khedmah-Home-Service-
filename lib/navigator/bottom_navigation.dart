import 'package:flutter/material.dart';
import 'package:rizek/screens/bottom_nav_screens/home.dart';
import '../screens/bottom_nav_screens/notification.dart';
import '../screens/bottom_nav_screens/booking.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar();

  @override
  _BottomNavigationState createState() => new _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavBar>{

  int _currentIndex = 0;
  final List<Widget> _children = [
    Home(),
    Booking(),
    Notifications(),

  ];


  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }




  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Color(0xffb2d0dc),
        selectedItemColor: Color(0xff0ba9da),
        onTap: onTabTapped, // new
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: Text("Home")
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.calendar_today),
              title: Text("Booking")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              title: Text("Notification")
          ),
        ],
      ),
      body: _children[_currentIndex],
    );
  }
}
