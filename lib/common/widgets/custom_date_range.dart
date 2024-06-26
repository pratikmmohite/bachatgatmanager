/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:flutter/material.dart';

class CustomDateRange extends StatefulWidget {
  final String label;
  final String field;
  final DateTime sdt;
  final DateTime edt;
  final ValueChanged<DateTimeRange> onChange;
  const CustomDateRange(
      {super.key,
      required this.label,
      required this.field,
      required this.sdt,
      required this.edt,
      required this.onChange});

  @override
  State<CustomDateRange> createState() => _CustomDateRangeState();
}

class _CustomDateRangeState extends State<CustomDateRange> {
  String formatDt(DateTime dt) {
    return dt.toString().split(" ")[0];
  }

  @override
  Widget build(BuildContext context) {
    var dt = DateTimeRange(start: widget.sdt, end: widget.edt);
    var dtStr = "${formatDt(dt.start)} - ${formatDt(dt.end)}";
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: "Enter ${widget.label}",
        filled: true,
      ),
      initialValue: dtStr,
      onTap: () async {
        DateTimeRange? selectedDate = await showDateRangePicker(
            context: context,
            initialDateRange: dt,
            firstDate: DateTime(2000),
            lastDate: DateTime(2099));
        if (selectedDate != null) {
          widget.onChange(selectedDate);
        }
      },
    );
  }
}
