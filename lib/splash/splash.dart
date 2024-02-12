import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker/Auth/login.dart';
import 'package:tracker/Auth/userType.dart';
import 'package:tracker/Home/home.dart';
import 'package:tracker/Intro/intro.dart';
import 'package:tracker/Map/mapTracked.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int timeout = 0;

  getStart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Timer(Duration(seconds: 6), () {
      setState(() {
        timeout = 1;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // Add a delay to simulate the loading process
    getStart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: timeout == 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Add your logo or any splash content here
                    Image.asset('assets/logo.png', width: 150, height: 150),
                    SizedBox(height: 16),
                    Text(
                      'Kids Tracking App',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              : FutureBuilder(
                  future: SharedPreferences.getInstance(),
                  builder: (BuildContext context,
                      AsyncSnapshot<SharedPreferences> prefs) {
                    var x = prefs.data;
                    if (prefs.hasData) {
                      if (x?.getInt('isLoggedIn') != null) {
                        if (x?.getInt('isLoggedIn') == 1) {
                          return MaterialApp(
                            color: Colors.white,
                            home: UserType(),
                            debugShowCheckedModeBanner: false,
                          );
                        } else {
                          return MaterialApp(
                            color: Color.fromARGB(255, 240, 240, 240),
                            home: x?.getInt("userType") == 1
                                ? HomeScreen()
                                : trackedMapTracked(),
                            debugShowCheckedModeBanner: false,
                          );
                        }
                      }
                    }
                    return MaterialApp(
                      color: Color.fromARGB(255, 240, 240, 240),
                      home: OnboardingScreen(),
                      debugShowCheckedModeBanner: false,
                    );
                  })),
    );
  }
}
