import 'package:flutter/material.dart';

class CustomDateRange extends StatelessWidget {
  String label;
  String field;
  DateTime sdt;
  DateTime edt;
  ValueChanged<DateTimeRange> onChange;
  CustomDateRange(
      {super.key,
      required this.label,
      required this.field,
      required this.sdt,
      required this.edt,
      required this.onChange});

  @override
  Widget build(BuildContext context) {
    var dt = DateTimeRange(start: sdt, end: edt);
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        hintText: "Enter $label",
        filled: true,
      ),
      initialValue: dt.toString(),
      onTap: () async {
        DateTimeRange? selectedDate = await showDateRangePicker(
            context: context,
            initialDateRange: dt,
            firstDate: DateTime(2000),
            lastDate: DateTime(2099));
        if (selectedDate != null) {
          onChange(selectedDate);
        }
      },
    );
  }
}
