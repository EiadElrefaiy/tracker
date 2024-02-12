import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker/Auth/login.dart';
import 'package:tracker/Auth/userType.dart';
import 'package:tracker/CreateDevice/createDevice.dart';
import 'package:tracker/Map/map.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDateTime =
        DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);
    return formattedDateTime;
  }

  Future<List<Map<String, dynamic>>> fetchDataFromServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString("token");

    final Uri apiUrl = Uri.parse(
        'https://exposss.com/tracking_project/public/api/user/user-devices');

    try {
      final response = await http.post(
        apiUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response and return the list of devices
        final Map<String, dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['devices']);
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load data from the server');
      }
    } catch (e) {
      // Handle network or other errors
      throw Exception('Failed to make the request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateDevice()),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        elevation: 0, // Set elevation to 0 to remove the shadow
        highlightElevation:
            0, // Set highlightElevation to 0 to remove the shadow on press
        backgroundColor: Color(0xFFDC931D), // Set background color as needed
      ),
      appBar: AppBar(
        title: Text('Tracker App'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications),
            tooltip: "الاشعارات",
          )
        ],
      ),
      drawer: Drawer(
        // Add your drawer content here
        child: ListView(
          children: [
            Container(
              height: 250,
              child: Image.asset(
                'assets/logo.png', // Replace with your image path
                fit: BoxFit.fill, // Use BoxFit.cover to fill the container
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                // Handle profile item tap
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle settings item tap
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log out'),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setInt("isLoggedIn", 1);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => UserType()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            // Add more items as needed
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: 300,
            child: Image.asset(
              'assets/home.png', // Replace with your image path
              fit: BoxFit.fill, // Use BoxFit.cover to fill the container
            ),
          ),
          Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchDataFromServer(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Center(child: Text('No Devices Available')));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    final device = snapshot.data?[index];

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Card(
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16.0),
                              leading: Image.asset(
                                'assets/phone.png',
                                width: 100,
                                height: 60,
                              ),
                              title: Text(
                                'Device : ${device?['name']}',
                                style: TextStyle(fontSize: 14.0),
                              ),
                              subtitle: Text(
                                'Device ID: ${device?['deviceID']}\nCreated at: ${formatDateTime(device?['created_at'])}',
                              ),
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setInt("device_id", device?['id']);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => trackedMapUser(),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    );
                  },
                );
              }
            },
          )),
        ],
      ),
    );
  }
}
