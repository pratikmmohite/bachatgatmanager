import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  String label;
  String field;
  String value;
  int? maxLines;
  TextInputType? keyboardType;
  ValueChanged<String>? onChange;

  CustomTextField(
      {super.key,
      required this.label,
      required this.field,
      required this.value,
      this.maxLines,
      this.keyboardType,
      this.onChange});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChange,
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        hintText: "Enter $label",
        filled: true,
      ),
    );
  }
}
