import 'package:flutter/material.dart';

class CustomDateField extends StatelessWidget {
  final String label;
  final String field;
  final DateTime value;
  final ValueChanged<DateTime> onChange;

  const CustomDateField({
    super.key,
    required this.label,
    required this.field,
    required this.value,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          hintText: value.toString().split(" ")[0],
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
      ),
    );
  }
}
