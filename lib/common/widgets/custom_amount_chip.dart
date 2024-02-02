import 'package:flutter/material.dart';

class CustomAmountChip extends StatelessWidget {
  final double amount;
  final String label;
  CustomAmountChip({
    super.key,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Text("₹.$amount"),
      ],
    );
  }
}
