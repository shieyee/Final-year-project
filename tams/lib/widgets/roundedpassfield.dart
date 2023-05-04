import 'package:flutter/material.dart';
import 'package:tams/constants.dart';
import 'package:tams/widgets/textfieldcontainer.dart';

class RoundedPasswordField extends StatelessWidget {
  final TextEditingController controller;
  const RoundedPasswordField({ Key? key, required this.controller }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        controller: controller,
        obscureText: true,
        cursorColor: kPrimaryColor,
         decoration: const InputDecoration(
            icon: Icon(
              Icons.lock,
              color: kPrimaryColor,
            ),
            hintText: "Password",
            hintStyle:  TextStyle(fontFamily: 'OpenSans'),
            suffixIcon: Icon(
              Icons.visibility,
              color: kPrimaryColor,
            ),
            border: InputBorder.none),
      ),
    );
  }
}