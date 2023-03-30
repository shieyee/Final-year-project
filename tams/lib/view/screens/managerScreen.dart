import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ManagerScreen extends StatefulWidget {
  const ManagerScreen({super.key});

  @override
  State<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Manager")),
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
                        Icon(Icons.wind_power_outlined, size: 50), // icon
                        Text("Manage Tender",
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