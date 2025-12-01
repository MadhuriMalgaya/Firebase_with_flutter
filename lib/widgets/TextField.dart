import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFieldData extends StatelessWidget {

  final String hintText, label;
  TextEditingController controller = TextEditingController();
  IconData? prefixIcon;
  IconData? suffixIcon;
  bool obscureText;
  final VoidCallback? onSuffixTap;
  FormFieldValidator? validator;

  TextFieldData({super.key,
    required this.controller,
    required this.hintText,
    required this.label,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.onSuffixTap,
    this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            hintText: hintText,
            label: Text(label),
            prefixIcon: Icon(prefixIcon),
            suffixIcon: InkWell(
              onTap: onSuffixTap,
              child: Icon(suffixIcon),
            ),
        ),
        validator: validator,
      ),
    );
  }
}
