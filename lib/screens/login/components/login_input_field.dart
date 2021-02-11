import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginInputField extends StatelessWidget {
  const LoginInputField({
    Key key,
    @required this.controller,
    this.validator,
    this.prefix,
    this.hintText,
    this.maxLength, this.readOnly,
  }) : super(key: key);

  final TextEditingController controller;
  final Function validator;
  final String prefix, hintText;
  final int maxLength;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
      ],
      validator: validator,
      maxLength: maxLength,
      maxLengthEnforced: true,
      cursorColor: Colors.black,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        prefix: Text(prefix),
        icon: Icon(Icons.phone, color: Colors.black),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black),
      ),
    );
  }
}
