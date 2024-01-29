import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  String label;
  String field;
  String value;
  int? maxLines;
  TextInputType? keyboardType;
  ValueChanged<String>? onChange;
  bool isRequired;
  bool readOnly;

  CustomTextField(
      {super.key,
      required this.label,
      required this.field,
      required this.value,
      this.maxLines,
      this.keyboardType,
      this.onChange,
      this.isRequired = false,
      this.readOnly = false});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChange,
      initialValue: widget.value,
      validator: widget.isRequired
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'Required*';
              }
              return null;
            }
          : null,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: "Enter ${widget.label}",
        filled: true,
      ),
    );
  }
}
