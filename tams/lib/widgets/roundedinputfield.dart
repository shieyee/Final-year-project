import 'package:flutter/material.dart';
import 'package:tams/constants.dart';
import 'package:tams/widgets/textfieldcontainer.dart';

class RoundedInputField extends StatelessWidget {
  const RoundedInputField({Key? key, this.hintText, this.icon = Icons.person, required this.controller, this.validator, this.suffixIcon, this.keyboardType})
      : super(key: key);
  final String? hintText;
  final IconData icon;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;
   final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
           suffixIcon: suffixIcon,
            icon: Icon(
              icon,
              color: kPrimaryColor,
            ),
            hintText: hintText,
            hintStyle: const TextStyle(fontFamily: 'OpenSans'),
            border: InputBorder.none),
            validator: validator,
      ),
    );
  }
}
