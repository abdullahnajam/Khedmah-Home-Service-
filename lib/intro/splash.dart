import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rizek/intro/onboarding.dart';
import 'package:rizek/main.dart';
import 'package:rizek/data/values.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../navigator/bottom_navigation.dart';

class SplashScreen extends StatefulWidget {
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 5;
  User user;

  getCurrentUser()async{
    user=await FirebaseAuth.instance.currentUser;
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    if(user!=null){
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => BottomNavBar(user.uid,true)));
    }
    else{
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => OnBoarding()));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height,
          child: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("APP NAME",style: TextStyle(fontSize: 35,fontWeight: FontWeight.w500,color: Colors.white),)
            ],
          )),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [primaryColor, backgroundColor]))),
    );
  }
}

