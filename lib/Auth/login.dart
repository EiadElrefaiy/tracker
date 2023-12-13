import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tracker/Home/home.dart';
import 'package:tracker/splash/splash.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

bool isLoading = false;
String ivaledAlert = "";
String username_login = "";
String password_login = "";

Color existedColor = Colors.grey;
OutlineInputBorder outlinedInputBorder = new OutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    borderSide: BorderSide(color: existedColor, width: 2));

TextStyle textStyle = new TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.bold,
  color: existedColor,
);

class _LoginState extends State<Login> {
  /*
  login(String username, String password) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool check = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
    if (check == true) {
      try {
        setState(() {
          isLoading = true;
        });
        var url =
            "https://laughing-kepler.198-244-243-29.plesk.page/golden-hr/public/api/v1/admins/login-emp";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "username": username,
            "password": password,
          }),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          if (responseBody['status'] == true) {
            setDataAndToken() async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("token", responseBody['emp']['api_token']);
              prefs.setInt("id", responseBody['emp']['id']);
              prefs.setString("name", responseBody['emp']['name']);
              prefs.setString("phone", responseBody['emp']['phone']);
              prefs.setString("address", responseBody['emp']['address']);
              prefs.setInt("money", responseBody['emp']['money']);
              prefs.setString("username", responseBody['emp']['username']);
              prefs.setInt("existed", responseBody['emp']['existed']);
              prefs.setString("created_at", responseBody['emp']['created_at']);

              prefs.setInt('isLoggedIn', 2);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
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
          return responseBody;
        } else {
          Fluttertoast.showToast(
              msg: "فشل تسجيل الدخول",
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white,
              fontSize: 16,
              backgroundColor: Colors.grey[800]);
        }
      } catch (e) {
        print(e);
      }

      setState(() {
        isLoading = false;
      });
    } else {
      Fluttertoast.showToast(
          msg: "خطأ في الاتصال",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
          fontSize: 16,
          backgroundColor: Colors.grey[800]);
    }
  }
  */

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
                          "Login In Now",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "please login to continue using app",
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
                          //initialValue: initial,
                          //keyboardType: widget.textInputType,
                          //cursorColor: existedColor,
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
                          height: 25,
                        ),
                        TextFormField(
                          //initialValue: initial,
                          //keyboardType: widget.textInputType,
                          //cursorColor: existedColor,
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
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  print("success");
                                  print(username_login);
                                  print(password_login);
                                  //login(username_login, password_login);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()),
                                  );
                                }
                              },
                              child: Text(
                                "login",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
        )));
  }
}
