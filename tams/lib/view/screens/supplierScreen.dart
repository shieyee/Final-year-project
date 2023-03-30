import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({super.key});

  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Supplier")),
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
                        Icon(Icons.yard, size: 50), // icon
                        Text("Submit Tender",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold)), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
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
                        Icon(Icons.yard, size: 50), // icon
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