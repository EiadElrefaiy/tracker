import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker/Auth/login.dart';
import 'package:http/http.dart' as http;
import 'package:tracker/Auth/userType.dart';

class trackedMapTracked extends StatefulWidget {
  @override
  trackedMapState createState() => trackedMapState();
}

class trackedMapState extends State<trackedMapTracked> {
  late GoogleMapController mapController;
  Position? currentPosition;
  Timer? _locationTimer;

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await requestLocationPermission();
    } else if (permission == LocationPermission.deniedForever) {
      // Handle the case where the user has permanently denied location permission
    } else {
      await getCurrentLocation();
    }
  }

  Future<void> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle the case where the user denies location permission
    } else if (permission == LocationPermission.deniedForever) {
      // Handle the case where the user has permanently denied location permission
    } else {
      await getCurrentLocation();
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() async {
        currentPosition = position;
        print(currentPosition!.longitude);
        print(currentPosition!.latitude);

        SharedPreferences prefs = await SharedPreferences.getInstance();

        var token = prefs.getString("token");
        final Uri apiUrl = Uri.parse(
            'https://exposss.com/tracking_project/public/api/tracked/update-devices');

        try {
          final response = await http.post(
            apiUrl,
            body: jsonEncode({
              'long': currentPosition!.longitude,
              'lat': currentPosition!.latitude,
              'deviceID': prefs.getString("deviceID"),
            }),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          );

          if (response.statusCode == 200) {
            // Handle success, you may want to navigate to a new screen or show a success message
            setState(() {});
          } else {
            Fluttertoast.showToast(
                msg: "خطأ في الاتصال",
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white,
                fontSize: 16,
                backgroundColor: Colors.grey[800]);
            print(
                'Failed to add Tracked ID. Status code: ${response.statusCode}');
          }
          _locationTimer = Timer(Duration(seconds: 15), () {
            if (mounted) {
              getCurrentLocation();
            }
          });
        } catch (e) {
          // Handle network or other errors
          print('Error: $e');
        }
      });

      // Schedule the next call after 15 seconds even if there is an error
      _locationTimer = Timer(Duration(seconds: 15), () {
        if (mounted) {
          getCurrentLocation();
        }
      });
    } catch (e) {
      // Handle exceptions while fetching location
      print("Error: $e");
    }
  }

  Future<bool> isLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  String? deviceID;

  deviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    deviceID = prefs.getString("deviceID");
  }

  @override
  void initState() {
    super.initState();
    deviceId();
    checkLocationPermission();
    initializeMap();
  }

  Future<void> initializeMap() async {
    bool locationEnabled = await isLocationEnabled();
    if (locationEnabled) {
      await checkLocationPermission();
    } else {
      // Handle case where location services are disabled
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(deviceID ?? ""),
            IconButton(
              icon: Icon(Icons.copy),
              onPressed: () {
                _copyToClipboard(deviceID!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Copied to clipboard: $deviceID'),
                  ),
                );
              },
            ),
          ],
        ),
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
      body: currentPosition != null
          ? GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  mapController = controller;
                });
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  currentPosition!.latitude,
                  currentPosition!.longitude,
                ),
                zoom: 17.0,
              ),
              markers: <Marker>[
                Marker(
                  markerId: MarkerId('current_location'),
                  position: LatLng(
                    currentPosition!.latitude,
                    currentPosition!.longitude,
                  ),
                  infoWindow: InfoWindow(title: 'Current Location'),
                ),
              ].toSet(),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
