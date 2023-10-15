import 'package:flutter/material.dart';

class CustomDateField extends StatelessWidget {
  String label;
  String field;
  DateTime value;
  ValueChanged<DateTime> onChange;

  CustomDateField({
    super.key,
    required this.label,
    required this.field,
    required this.value,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: value.toString(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: true,
      ),
      readOnly: true,
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: value,
            firstDate: DateTime(2000),
            lastDate: DateTime(2099));
        if (selectedDate != null) {
          onChange(selectedDate);
        }
      },
    );
  }
}
