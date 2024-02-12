import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tracker/Home/home.dart';
import 'package:tracker/splash/splash.dart';

class CreateDevice extends StatefulWidget {
  @override
  CreateDevicePageState createState() => CreateDevicePageState();
}

String ivaledAlert = "";
String tracked_id = "";
String device_name = "";

Color existedColor = Colors.grey;
OutlineInputBorder outlinedInputBorder = new OutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    borderSide: BorderSide(color: existedColor, width: 2));

TextStyle textStyle = new TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.bold,
  color: existedColor,
);

class CreateDevicePageState extends State<CreateDevice> {
  addTrackedId(trackedId, deviceName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString("token");
    final Uri apiUrl = Uri.parse(
        'https://exposss.com/tracking_project/public/api/user/create-device');

    try {
      final response = await http.post(
        apiUrl,
        body: jsonEncode({
          'name': deviceName,
          'deviceID': trackedId,
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Handle success, you may want to navigate to a new screen or show a success message
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (Route<dynamic> route) => false,
        );
      } else {
        Fluttertoast.showToast(
            msg: "خطأ في كود الجهاز",
            toastLength: Toast.LENGTH_SHORT,
            textColor: Colors.white,
            fontSize: 16,
            backgroundColor: Colors.grey[800]);
        print('Failed to add Tracked ID. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
    }
  }

  TextEditingController _idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Tracked ID'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Textbox with placeholder

              TextFormField(
                cursorColor: existedColor,
                style: textStyle,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: "Device Name",
                  errorStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                  prefixIcon: Icon(
                    Icons.mobile_screen_share,
                    size: 30,
                    color: Colors.grey,
                  ),
                  hintStyle: textStyle,
                  contentPadding:
                      EdgeInsets.only(top: 10, right: 25, bottom: 10, left: 10),
                  disabledBorder: outlinedInputBorder,
                  enabledBorder: outlinedInputBorder,
                  focusedBorder: outlinedInputBorder,
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.red, width: 2)),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      width: 2,
                      color: Colors.red,
                    ),
                  ),
                ),
                onChanged: (value) {
                  device_name = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      existedColor = Colors.red;
                    });
                    return 'please enter tracked id';
                  }
                  /*
                      if (!RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$').hasMatch(value)) {
                        setState(() {
                          existedColor = Colors.red;
                        });
                        return 'خطأ في اسم المستخدم';
                      }
                      */
                },
              ),

              SizedBox(
                height: 20,
              ),

              TextFormField(
                cursorColor: existedColor,
                style: textStyle,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: "Tracked ID",
                  errorStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.grey,
                  ),
                  hintStyle: textStyle,
                  contentPadding:
                      EdgeInsets.only(top: 10, right: 25, bottom: 10, left: 10),
                  disabledBorder: outlinedInputBorder,
                  enabledBorder: outlinedInputBorder,
                  focusedBorder: outlinedInputBorder,
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.red, width: 2)),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      width: 2,
                      color: Colors.red,
                    ),
                  ),
                ),
                onChanged: (value) {
                  tracked_id = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      existedColor = Colors.red;
                    });
                    return 'please enter tracked id';
                  }
                  /*
                      if (!RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$').hasMatch(value)) {
                        setState(() {
                          existedColor = Colors.red;
                        });
                        return 'خطأ في اسم المستخدم';
                      }
                      */
                },
              ),

              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFDC931D),
                      shape: StadiumBorder(),
                    ),
                    onPressed: () {
                      addTrackedId(tracked_id, device_name);
                    },
                    child: Text(
                      "Add Tracked ID",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
              ),

              SizedBox(
                  height:
                      16.0), // Adding some space between the textbox and other widgets

              // Add more widgets or functionality as needed
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _idController.dispose();
    super.dispose();
  }
}
