import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tracker/Auth/login.dart';
import 'package:flutter/gestures.dart';
import 'package:tracker/Home/home.dart';
import 'package:tracker/Map/mapTracked.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

bool isLoading = false;
String ivaledAlert = "";
String username_login = "";
String password_login = "";
String password_confirmation = "";

Color existedColor = Colors.grey;
OutlineInputBorder outlinedInputBorder = new OutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    borderSide: BorderSide(color: existedColor, width: 2));

TextStyle textStyle = new TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.bold,
  color: existedColor,
);

class _SignupState extends State<Signup> {
  signup(String username, String password, String password_confirmation) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool check = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
    if (check == true) {
      try {
        setState(() {
          isLoading = true;
        });
        var url = "https://exposss.com/tracking_project/public/api/register";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "username": username,
            "password": password,
            "password_confirmation": password_confirmation
          }),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          if (responseBody['status'] == true) {
            setDataAndToken() async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("token", responseBody['token']);
              prefs.setInt("id", responseBody['user']['id']);
              prefs.setString("username", responseBody['user']['username']);

              prefs.setInt('isLoggedIn', 2);

              setState(() {
                isLoading = false;
              });

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false,
              );
            }

            setDataAndToken();
          } else {
            setState(() {
              isLoading = false;
              ivaledAlert = "invalid username or password";
            });
          }
        } else {
          Fluttertoast.showToast(
              msg: "فشل تسجيل الدخول",
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white,
              fontSize: 16,
              backgroundColor: Colors.grey[800]);

          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        print(e);
      }
    } else {
      Fluttertoast.showToast(
          msg: "خطأ في الاتصال",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
          fontSize: 16,
          backgroundColor: Colors.grey[800]);

      setState(() {
        isLoading = false;
      });
    }
  }

  signupTracked(
      String username, String password, String password_confirmation) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool check = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
    if (check == true) {
      try {
        setState(() {
          isLoading = true;
        });
        var url =
            "https://exposss.com/tracking_project/public/api/register-tracked";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "username": username,
            "password": password,
            "password_confirmation": password_confirmation
          }),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          if (responseBody['status'] == true) {
            setDataAndToken() async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("token", responseBody['token']);
              prefs.setInt("id", responseBody['tracked']['id']);
              prefs.setString("username", responseBody['tracked']['username']);
              prefs.setString("deviceID", responseBody['tracked']['deviceID']);

              prefs.setInt('isLoggedIn', 2);

              setState(() {
                isLoading = false;
              });

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => trackedMapTracked()),
                (Route<dynamic> route) => false,
              );
            }

            setDataAndToken();
          } else {
            setState(() {
              isLoading = false;
              ivaledAlert = "invalid username or password";
            });
          }
        } else {
          Fluttertoast.showToast(
              msg: "فشل تسجيل الدخول",
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white,
              fontSize: 16,
              backgroundColor: Colors.grey[800]);
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        print(e);
      }
    } else {
      Fluttertoast.showToast(
          msg: "خطأ في الاتصال",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
          fontSize: 16,
          backgroundColor: Colors.grey[800]);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar();
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          color: Colors.white,
          height: screenHeight,
          child: isLoading == true
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        color: Color(0xff61B1DF),
                      ), //show this if state is loading
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 120,
                        ),
                        Image.asset(
                          'assets/Login.png',
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Sign up Now",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "please sign in continue using app",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ivaledAlert,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          cursorColor: existedColor,
                          style: textStyle,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: "Username",
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
                            contentPadding: EdgeInsets.only(
                                top: 10, right: 25, bottom: 10, left: 10),
                            disabledBorder: outlinedInputBorder,
                            enabledBorder: outlinedInputBorder,
                            focusedBorder: outlinedInputBorder,
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2)),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            username_login = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                existedColor = Colors.red;
                              });
                              return 'please enter username';
                            }

                            if (!RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$')
                                .hasMatch(value)) {
                              setState(() {
                                existedColor = Colors.red;
                              });
                              return 'خطأ في اسم المستخدم';
                            }
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          cursorColor: existedColor,
                          style: textStyle,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Password",
                            errorStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              size: 30,
                              color: Colors.grey,
                            ),
                            hintStyle: textStyle,
                            contentPadding: EdgeInsets.only(
                                top: 10, right: 25, bottom: 10, left: 10),
                            disabledBorder: outlinedInputBorder,
                            enabledBorder: outlinedInputBorder,
                            focusedBorder: outlinedInputBorder,
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2)),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            password_login = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                existedColor = Colors.red;
                              });
                              return 'please enter password';
                            }

                            if (!RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$')
                                .hasMatch(value)) {
                              setState(() {
                                existedColor = Colors.red;
                              });
                              return 'خطأ في اسم المستخدم';
                            }
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          cursorColor: existedColor,
                          style: textStyle,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Comfirm Password",
                            errorStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              size: 30,
                              color: Colors.grey,
                            ),
                            hintStyle: textStyle,
                            contentPadding: EdgeInsets.only(
                                top: 10, right: 25, bottom: 10, left: 10),
                            disabledBorder: outlinedInputBorder,
                            enabledBorder: outlinedInputBorder,
                            focusedBorder: outlinedInputBorder,
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2)),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            password_confirmation = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                existedColor = Colors.red;
                              });
                              return 'please enter password';
                            }

                            if (!RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$')
                                .hasMatch(value)) {
                              setState(() {
                                existedColor = Colors.red;
                              });
                              return 'خطأ في اسم المستخدم';
                            }
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFDC931D),
                                shape: StadiumBorder(),
                              ),
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                int? user_type = prefs.getInt("userType");
                                if (_formKey.currentState!.validate()) {
                                  print("success");
                                  print(username_login);
                                  print(password_login);
                                  print(password_confirmation);

                                  if (user_type == 1) {
                                    signup(username_login, password_login,
                                        password_confirmation);
                                  } else {
                                    signupTracked(username_login,
                                        password_login, password_confirmation);
                                  }
                                }
                              },
                              child: Text(
                                "sign up",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Already have account? ",
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        )));
  }
}
