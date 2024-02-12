import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class trackedMapUser extends StatefulWidget {
  @override
  trackedMapState createState() => trackedMapState();
}

class trackedMapState extends State<trackedMapUser> {
  late GoogleMapController mapController;
  double? currentPositionLong;
  double? currentPositionLat;
  bool? isLoading;
  int i = 1;
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
    if (i == 1) {
      setState(() {
        isLoading = true;
      });
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var id = prefs.getInt("device_id");

    final String apiUrl =
        'https://exposss.com/tracking_project/public/api/user/device/$id';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Assuming the API response contains a 'tracked' list
        List<dynamic> trackedList = data['tracked'];

        if (trackedList.isNotEmpty) {
          Map<String, dynamic> trackedData = trackedList[0];

          // Access the data as needed
          int id = trackedData['id'];
          String username = trackedData['username'];
          currentPositionLat = double.parse(trackedData['location_lat']);
          currentPositionLong = double.parse(trackedData['location_long']);
          String deviceID = trackedData['deviceID'];
          DateTime createdAt = DateTime.parse(trackedData['created_at']);
          DateTime updatedAt = DateTime.parse(trackedData['updated_at']);

          // Now you can use the retrieved data as needed
          print('ID: $id');
          print('Username: $username');
          print('Location Lat: $currentPositionLat');
          print('Location Long: $currentPositionLong');
          print('Device ID: $deviceID');
          print('Created At: $createdAt');
          print('Updated At: $updatedAt');

          if (i == 1) {
            setState(() {
              isLoading = false;
            });
          }
          // Schedule the next call after 15 seconds
          _locationTimer = Timer(Duration(seconds: 15), () {
            if (mounted) {
              getCurrentLocation();
            }
          });
        } else {
          print('Tracked data is empty');
          if (i == 1) {
            setState(() {
              isLoading = false;
            });
          }
        }
      } else {
        // Handle errors
        print('Failed to fetch location. Status code: ${response.statusCode}');
        if (i == 1) {
          setState(() {
            isLoading = false;
          });
        }

        // Schedule the next call after 15 seconds even if there is an error
        _locationTimer = Timer(Duration(seconds: 15), () {
          if (mounted) {
            getCurrentLocation();
          }
        });
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
      if (i == 1) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }

      // Schedule the next call after 15 seconds even if there is an error
      _locationTimer = Timer(Duration(seconds: 15), () {
        if (mounted) {
          getCurrentLocation();
        }
      });
    }
    i++;
  }

  Future<bool> isLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: isLoading == false
          ? GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  mapController = controller;
                });
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  currentPositionLat!,
                  currentPositionLong!,
                ),
                zoom: 17.0,
              ),
              markers: <Marker>[
                Marker(
                  markerId: MarkerId('current_location'),
                  position: LatLng(
                    currentPositionLat!,
                    currentPositionLong!,
                  ),
                  infoWindow: InfoWindow(title: 'Current Location'),
                ),
              ].toSet(),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
