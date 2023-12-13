import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle the press event
          // Add your desired functionality here
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
              onTap: () {
                // Handle settings item tap
                Navigator.pop(context);
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
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5, // Adjust aspect ratio as needed
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Card(
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Image.asset('assets/device.png',
                            width: 100, height: 60),
                        Text(
                          'Device ${index + 1}',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
