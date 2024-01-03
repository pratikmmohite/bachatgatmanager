import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  String label;
  String field;
  String value;
  int? maxLines;
  TextInputType? keyboardType;
  ValueChanged<String>? onChange;
  bool isRequired;

  CustomTextField(
      {super.key,
      required this.label,
      required this.field,
      required this.value,
      this.maxLines,
      this.keyboardType,
      this.onChange,
      this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChange,
      initialValue: value,
      validator: isRequired
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'Required*';
              }
              return null;
            }
          : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: "Enter $label",
        filled: true,
      ),
    );
  }
}
