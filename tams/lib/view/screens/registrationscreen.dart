import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:tams/components/pagetitlebar.dart';
import 'package:tams/components/underpart.dart';
import 'package:tams/components/upside.dart';
import 'package:tams/view/screens/loginscreenn.dart';
import 'package:tams/view/shared/config.dart';
import 'package:tams/widgets/roundedRegReenterpassfield.dart';
import 'package:tams/widgets/roundedRegpassfield.dart';
import 'package:tams/widgets/roundedbutton.dart';
import 'package:tams/widgets/roundedinputfield.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _reenterpassController;
  late TextEditingController _contactnoController;
  bool _passwordVisible = true;
  final _formKey = GlobalKey<FormState>();
  late String _username = '';
  late String _email = '';
  late String _password = '';
  late String _reenterpass = '';
  late String _contactno = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _reenterpassController.dispose();
    _contactnoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _reenterpassController = TextEditingController();
    _contactnoController = TextEditingController();
    // _loadCredentials();
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
                const PageTitleBar(title: 'Create New Account'),
                Padding(
                  padding: const EdgeInsets.only(top: 320.0),
                  child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          )),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Form(
                                key: _formKey,
                                child: Column(children: [
                                  RoundedInputField(
                                    hintText: "Username",
                                    icon: Icons.person,
                                    controller: _usernameController,
                                    validator: (val) =>
                                        val!.isEmpty || (val.length < 3)
                                            ? "Username must be longer than 3"
                                            : null,
                                  ),
                                  RoundedInputField(
                                    hintText: "Email",
                                    icon: Icons.email,
                                    controller: _emailController,
                                    validator: (val) => val!.isEmpty ||
                                            !val.contains("@") ||
                                            !val.contains(".")
                                        ? "Please enter a valid email"
                                        : null,
                                  ),
                                  RoundedRegPasswordField(
                                    controller: _passwordController,
                                    validator: (val) =>
                                        validatePassword(val.toString()),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                  RoundedRegReenterPasswordField(
                                    controller: _reenterpassController,
                                    validator: (val) =>
                                        validatePassword(val.toString()),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                  RoundedInputField(
                                    hintText: "Contact No",
                                    keyboardType: TextInputType.number,
                                    icon: Icons.phone,
                                    controller: _contactnoController,
                                    validator: (val) => val!.isEmpty ||
                                            (val.length < 10)
                                        ? "Please enter valid contact number"
                                        : null,
                                  ),
                                  RoundedButton(
                                      text: 'REGISTER',
                                      press: () async {
                                        _registerAccount();
                                      }),
                                  RoundedButton(
                                      text: 'CANCEL',
                                      press: () async {
                                        cancelregisterAccount();
                                      }),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  UnderPart(
                                    title: "Already have an account?",
                                    navigatorText: "Login here",
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen()));
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ]))
                          ])),
                )
              ],
            ))),
      ),
    );
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.?[A-Z])(?=.?[a-z])(?=.*?[0-9]).{10,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Password minimum 10 characters';
      } else {
        return null;
      }
    }
  }

  void _registerAccount() {
    String username = _usernameController.text;
    String email = _emailController.text;
    String contactno = _contactnoController.text;
    String password = _passwordController.text;
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please fill in all the fields",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register new account?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _registerUser(username, email, contactno, password);
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _registerUser(
      String username, String email, String contactno, String password) {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Registration in progress.."),
        title: const Text("Registering..."));
    progressDialog.show();
    try {
      http.post(Uri.parse("${ServerConfig.SERVER}php/register_users.php"),
          body: {
            'username': username,
            'email': email,
            'contactno': contactno,
            'password': password,
            'register': 'register',
          }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == 'success') {
          Fluttertoast.showToast(
              msg: "Successfully Register",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 4,
              fontSize: 14.0);
          progressDialog.dismiss();
          return;
        } else {
          Fluttertoast.showToast(
              msg: "Failed to Register",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 4,
              fontSize: 14.0);
          progressDialog.dismiss();
          return;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void cancelregisterAccount() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }
}
