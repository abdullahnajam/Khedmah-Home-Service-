import 'package:flutter/material.dart';
import 'package:rizek/screens/bottom_nav_screens/home.dart';
import '../screens/bottom_nav_screens/notification.dart';
import '../screens/bottom_nav_screens/booking.dart';
import '../data/values.dart';

class BottomNavBar extends StatefulWidget {
  String uid;
  bool isLogin;

  BottomNavBar(this.uid,this.isLogin);

  @override
  _BottomNavigationState createState() => new _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavBar>{

  int _currentIndex = 0;

  List<Widget> _children=[];

  @override
  void initState() {
    super.initState();
    _children = [
      Home(widget.uid),
      Booking(widget.uid),
      Notifications(widget.uid),

    ];
  }

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
        unselectedItemColor: Color(0xffffd2ab),
        selectedItemColor: primaryColor,
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
