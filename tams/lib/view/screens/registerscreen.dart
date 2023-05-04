import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:tams/view/screens/loginscreen.dart';
import 'package:tams/view/screens/loginscreenn.dart';
import 'package:tams/view/shared/config.dart';
import 'package:ndialog/ndialog.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  // String dropdownitem = 'Staff';
  // var items = [
  //   'Staff',
  //   'Manager',
  //   'Supplier',
  // ];
  bool _passwordVisible = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reenterpassController = TextEditingController();
  final TextEditingController _contactnoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 194, 181, 212),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 8,
                margin: EdgeInsets.all(8),
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text("Register Account",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(
                          height: 15,
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
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) => val!.isEmpty ||
                                    !val.contains("@") ||
                                    !val.contains(".")
                                ? "Please enter a valid email"
                                : null,
                            decoration: const InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.email),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1.0),
                                ))),
                        TextFormField(
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _passwordVisible,
                            validator: (val) =>
                                validatePassword(val.toString()),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(),
                              icon: const Icon(Icons.password),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 1.0),
                              ),
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
                            )),
                        TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _passwordVisible,
                            controller: _reenterpassController,
                            validator: (val) {
                              validatePassword(val.toString());
                              if (val != _passwordController.text) {
                                return "Password Do Not Match";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Re-Password',
                              labelStyle: const TextStyle(),
                              icon: const Icon(Icons.password),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 1.0),
                              ),
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
                            )),
                        TextFormField(
                            controller: _contactnoController,
                            validator: (val) =>
                                val!.isEmpty || (val.length < 10)
                                    ? "Please enter valid contact number"
                                    : null,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Contact No',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.phone),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1.0),
                                ))),
                        // DropdownButtonFormField(
                        //   decoration: const InputDecoration(
                        //     icon: Icon(Icons.work),
                        //     labelText: 'Please select business type',
                        //   ),
                        //   value: dropdownitem,
                        //   icon: const Icon(Icons.keyboard_arrow_down),
                        //   items: items.map((String items) {
                        //     return DropdownMenuItem(
                        //       value: items,
                        //       child: Text(items),
                        //     );
                        //   }).toList(),
                        //   onChanged: (String? newValue) {
                        //     setState(() {
                        //       dropdownitem = newValue!;
                        //     });
                        //   },
                        // ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              minWidth: 100,
                              height: 50,
                              elevation: 10,
                              onPressed: _registerAccount,
                              color: Theme.of(context).colorScheme.primary,
                              child: const Text('APPLY'),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              minWidth: 100,
                              height: 50,
                              elevation: 10,
                              onPressed: cancelregisterAccount,
                              color: Theme.of(context).colorScheme.primary,
                              child: const Text('CANCEL'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Already Register?",
                      style: TextStyle(
                        fontSize: 16.0,
                      )),
                  GestureDetector(
                    onTap: () => {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => const LoginScreen()))
                    },
                    child: const Text(
                      "Login here",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              // const SizedBox(
              //   height: 5,
              // ),
              // GestureDetector(
              //   onTap: null,
              //   child: const Text(
              //     "Back to Home",
              //     style: TextStyle(
              //         fontSize: 16.0,
              //         fontWeight: FontWeight.bold,
              //         decoration: TextDecoration.underline),
              //   ),
              // ),
            ],
          ),
        ),
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
      http.post(Uri.parse("${ServerConfig.SERVER}php/register_users.php"), body: {
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
                    context,
                    MaterialPageRoute(
                        builder: (content) => const Login()));
  }
}
