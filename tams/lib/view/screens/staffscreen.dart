import 'package:flutter/material.dart';
import 'package:tams/models/user.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({
    super.key,
  });

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Staff")),
      body: Center(
        child: SingleChildScrollView(
            child: Container(
                child: Column(
          children: [
            SizedBox.fromSize(
              size: Size(150, 150), // button width and height
              child: ClipOval(
                child: Material(
                  color: Colors.blue, // button color
                  child: InkWell(
                    splashColor:
                        Color.fromARGB(255, 109, 21, 50), // splash color
                    onTap: null, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.anchor, size: 50), // icon
                        Text("Manage Asset",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold)), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ))),
      ),
    );
  }
}
