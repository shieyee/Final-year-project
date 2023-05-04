import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tams/models/user.dart';
import 'package:tams/view/screens/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:tams/view/screens/loginscreenn.dart';
import 'package:tams/view/screens/mainscreen.dart';
import 'package:tams/view/screens/registerscreen.dart';
import 'package:tams/view/shared/config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override //overide is the method already available in the system, and you want to reimplement other thing
  // void initState() {
  //   super.initState();
  //   autoLogin();
  // }

  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.push(context,
            MaterialPageRoute(builder: (content) => const LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/TAMS.png'),
                  fit: BoxFit.cover))),
      Padding(padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const[
          CircularProgressIndicator(),
          // Text("Version 1",
          // style: TextStyle(fontSize: 24,
          // fontWeight: FontWeight.bold),)
        ],
      ),)
    ]);
  }

  // Future<void> autoLogin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String username = (prefs.getString('username')) ?? '';
  //   String password = (prefs.getString('password')) ?? '';
  //   if (username.isNotEmpty) {
  //     http.post(Uri.parse("${ServerConfig.SERVER}php/login_user.php"),
  //         body: {"username": username, "password": password}).then((response) {
  //       var jsonResponse = json.decode(response.body);
  //       if (response.statusCode == 200 && jsonResponse['status'] == "success") {
  //         var jsonResponse = json.decode(response.body);
  //         User user = User.fromJson(jsonResponse['data']);
  //         Timer(
  //             const Duration(seconds: 3),
  //             () => Navigator.pushReplacement(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (content) => MainScreen(user: user))));
  //       } else {
  //         User user = User(
  //             id: "na",
  //             username: "na",
  //             email: "na",
  //             contactno: "na",
  //             regdate: "na",
  //             otp: "na");
  //         Timer(
  //             const Duration(seconds: 3),
  //             () => Navigator.pushReplacement(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (content) => MainScreen(user: user))));
  //       }
  //     });
  //   }
  // }
}
