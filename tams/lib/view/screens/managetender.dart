import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
      appBar:
          AppBar(title: const Text("Open Tender", style: TextStyle(fontSize: 17))),
      body: Container(),
    );
  }
}