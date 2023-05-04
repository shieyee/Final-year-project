import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tams/components/pagetitlebar.dart';
import 'package:tams/components/underpart.dart';
import 'package:tams/components/upside.dart';
import 'package:tams/constants.dart';
import 'package:tams/models/user.dart';
import 'package:tams/view/screens/mainscreen.dart';
import 'package:tams/view/screens/registerscreen.dart';
import 'package:tams/view/screens/registrationscreen.dart';
import 'package:tams/view/shared/config.dart';
import 'package:tams/widgets/roundedbutton.dart';
import 'package:tams/widgets/roundedinputfield.dart';
import 'package:tams/widgets/roundedpassfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _usernameController;
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  late String _username = '';
  late String _password = '';

  @override
  void dispose() {
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _loadCredentials();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                const Upside(
                  imgUrl: "assets/images/TAMSlogin.png",
                ),
                const PageTitleBar(title: 'Login your account'),
                Padding(
                  padding: const EdgeInsets.only(top: 320.0),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              
                              RoundedInputField(
                                hintText: "Username",
                                icon: Icons.person,
                                controller: _usernameController,
                          
                                validator: (val) =>
                                    val!.isEmpty || (val.length < 3)
                                        ? "Username must be longer than 3"
                                        : null,
                              ),
                              RoundedPasswordField(
                                controller: _passwordController,
                               
                              ),
                              switchListTile(),
                              RoundedButton(
                                  text: 'LOGIN',
                                  press: () async {
                                    if (_formKey.currentState!.validate()) {
                                      if (_isChecked) {
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        prefs.setString('username', _username);
                                        prefs.setString('password', _password);
                                         _loginUser();
                                      }
                                    }
                                  }),
                              const SizedBox(
                                height: 10,
                              ),
                              UnderPart(
                                title: "Don't have an account?",
                                navigatorText: "Register here",
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterScreen()));
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              
                              
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  switchListTile() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 40),
      child: SwitchListTile(
        dense: true,
        title: const Text(
          'Remember Me',
          style: TextStyle(fontSize: 16, fontFamily: 'OpenSans'),
        ),
        value: _isChecked,
        activeColor: kPrimaryColor,
        onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value!;
                              saveremovepref(value);
                            });
                          },
      ),
    );
  }

  Future<void> _loadCredentials() async {
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

  Future<void> saveremovepref(bool value) async {
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
}
