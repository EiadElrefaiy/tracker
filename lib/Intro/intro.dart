import 'package:flutter/material.dart';
import 'package:tracker/Auth/login.dart';
import 'package:tracker/Auth/signup.dart';
import 'package:tracker/Auth/userType.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

final PageController _pageController = PageController();

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;

  List<Map<String, String>> onboardingData = [
    {
      'title': 'Watch Your Kids',
      'description':
          'Through the application, you can track your child’s location and itinerary and receive an automatic alert if the places allocated to him run out',
      'image': 'assets/onboarding/onboarding1.png',
    },
    {
      'title': 'Watch Your Old People',
      'description':
          'Through the application, you can track the location of the elderly and check on their health condition',
      'image': 'assets/onboarding/onboarding2.png',
    },
    {
      'title': 'Keep Your Family Safe',
      'description':
          'Through the application, you can track the location of the elderly and check on their health condition',
      'image': 'assets/onboarding/onboarding3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: onboardingData.length,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemBuilder: (context, index) {
          return OnboardingPage(
            title: onboardingData[index]['title']!,
            description: onboardingData[index]['description']!,
            image: onboardingData[index]['image']!,
            pageNumber: _currentPage,
          );
        },
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final int pageNumber;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
    required this.pageNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            child: Container(
              width: 300, // Set the width of the container
              height: 300, // Set the height of the container
              child: Image.asset(
                image, // Replace with your image path
                fit: BoxFit.cover, // Use BoxFit.cover to fill the container
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width:
                    20.0, // Adjust the width to change the size of the circle
                height:
                    20.0, // Height is set to be equal to width for a perfect circle
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      pageNumber == 0 ? Color(0xFFdc931d) : Color(0xFFdcdee0),
                ),
              ),
              SizedBox(width: 10),
              Container(
                width:
                    20.0, // Adjust the width to change the size of the circle
                height:
                    20.0, // Height is set to be equal to width for a perfect circle
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      pageNumber == 1 ? Color(0xFFdc931d) : Color(0xFFdcdee0),
                ),
              ),
              SizedBox(width: 10),
              Container(
                width:
                    20.0, // Adjust the width to change the size of the circle
                height:
                    20.0, // Height is set to be equal to width for a perfect circle
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      pageNumber == 2 ? Color(0xFFdc931d) : Color(0xFFdcdee0),
                ),
              ),
            ],
          ),
          SizedBox(height: 60),
          ElevatedButton(
            onPressed: () {
              if (pageNumber == 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UserType()),
                );
              } else {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xFFDC931D)),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(vertical: 7.0, horizontal: 90.0),
              ),
            ),
            child: Text(
              pageNumber == 2 ? 'Get Start' : 'Next',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
