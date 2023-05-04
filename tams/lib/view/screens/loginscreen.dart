import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tams/models/user.dart';
import 'package:tams/view/screens/mainscreen.dart';
import 'package:tams/view/screens/manageasset.dart';
import 'package:tams/view/screens/registerscreen.dart';
import 'package:http/http.dart' as http;
import 'package:tams/view/shared/config.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final bool _passwordVisible = true;
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  var screenHeight, screenWidth, cardwidth;

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      cardwidth = screenWidth;
    } else {
      cardwidth = 400.00;
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 194, 181, 212),
      appBar: AppBar(
          title: const Text("Tender and Asset Management System",
              style: TextStyle(fontSize: 17))),
      body: Center(
          child: SingleChildScrollView(
              child: SizedBox(
                width: cardwidth,
        child: Card(
          elevation: 8,
          margin: const EdgeInsets.all(8),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text("Log In",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                      controller: _usernameController,
                      keyboardType: TextInputType.text,
                      validator: (val) => val!.isEmpty || (val.length < 3)
                          ? "Username must be longer than 3"
                          : null,
                      decoration: const InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.person),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.0),
                          ))),
                  TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(),
                        icon: Icon(Icons.password),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0),
                        ),
                      )),
                  const SizedBox(
                    height: 18,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value!;
                              saveremovepref(value);
                            });
                          },
                        ),
                        Flexible(
                          child: GestureDetector(
                            onTap: null,
                            child: const Text('Remember Me',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          minWidth: 115,
                          height: 50,
                          elevation: 10,
                          onPressed: _loginUser,
                          color: Theme.of(context).colorScheme.primary,
                          child: const Text('Login'),
                        ),
                      ]),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Need an Account? ",
                          style: TextStyle(fontSize: 16.0)),
                      GestureDetector(
                        onTap: () => {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const Registration()))
                        },
                        child: const Text(
                          " Register here",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ))),
    );
  }

  void _loginUser() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please fill in the login credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    String username = _usernameController.text;
    String password = _passwordController.text;
    http.post(Uri.parse("${ServerConfig.SERVER}php/login_user.php"),
    body: {"username": username, "password": password}).then((response){
    print(response.body);
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse['status'] == "success") {
        var jsonResponse = json.decode(response.body);
        User user = User.fromJson(jsonResponse['data']);
        print(user.username);
        Navigator.push(context,
            MaterialPageRoute(builder: (content) => MainScreen(user: user)));
      }else{
        Fluttertoast.showToast(
            msg: "Login Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      }
  });
}

void saveremovepref(bool value) async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      if (!_formKey.currentState!.validate()) {
        Fluttertoast.showToast(
            msg: "Please fill in the login credentials",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        _isChecked = false;
        return;
      }
      await prefs.setString('username', username);
      await prefs.setString('password', password);
      Fluttertoast.showToast(
          msg: "Preference Stored",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    } else {
      //delete preference
      await prefs.setString('username', '');
      await prefs.setString('password', '');
      setState(() {
        _usernameController.text = '';
        _passwordController.text = '';
        _isChecked = false;
      });
      Fluttertoast.showToast(
          msg: "Preference Removed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
  }

Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = (prefs.getString('username')) ?? '';
    String password = (prefs.getString('password')) ?? '';
    if (username.isNotEmpty) {
      setState(() {
        _usernameController.text = username;
        _passwordController.text = password;
        _isChecked = true;
      });
    }
  }
}