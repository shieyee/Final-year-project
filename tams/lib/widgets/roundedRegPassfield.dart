import 'package:flutter/material.dart';
import 'package:tams/constants.dart';
import 'package:tams/widgets/textfieldcontainer.dart';

class RoundedRegPasswordField extends StatelessWidget {
  final TextEditingController controller;
  const RoundedRegPasswordField({ Key? key, required this.controller, this.suffixIcon, this.validator }) : super(key: key);
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;

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