import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String field;
  final String value;
  final int? maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChange;
  final bool isRequired;
  final bool readOnly;
  final Widget? suffix;
  final Widget? prefix;

  const CustomTextField({
    super.key,
    required this.label,
    required this.field,
    required this.value,
    this.maxLines,
    this.keyboardType,
    this.onChange,
    this.suffix,
    this.prefix,
    this.isRequired = false,
    this.readOnly = false,
  });

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
        prefix: widget.prefix,
        suffix: widget.suffix,
      ),
    );
  }
}
