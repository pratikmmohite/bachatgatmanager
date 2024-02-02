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
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  const CustomTextField({
    super.key,
    required this.label,
    required this.field,
    required this.value,
    this.maxLines,
    this.keyboardType,
    this.onChange,
    this.suffixIcon,
    this.prefixIcon,
    this.isRequired = false,
    this.readOnly = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: TextFormField(
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
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
        ),
      ),
    );
  }
}
