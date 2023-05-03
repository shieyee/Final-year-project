import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tams/view/screens/newtenderscreen.dart';

class OpenTender extends StatefulWidget {
  const OpenTender({super.key});

  @override
  State<OpenTender> createState() => _OpenTenderState();
}

class _OpenTenderState extends State<OpenTender> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 194, 181, 212),
      appBar: AppBar(
          title: const Text("Open Tender", style: TextStyle(fontSize: 17))),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: ElevatedButton(
            onPressed: createNewTender,
            child: Text(
              "Create",
              style: TextStyle(
                fontSize: 15,
                letterSpacing: 1,
                color: Colors.black87,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createNewTender() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (content) => NewTender()));
  }
}
