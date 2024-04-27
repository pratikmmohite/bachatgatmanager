/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:flutter/material.dart';

class CustomAmountChip extends StatelessWidget {
  final double amount;
  final String prefix;
  final String label;
  final bool showInRow;
  const CustomAmountChip({
    super.key,
    required this.label,
    required this.amount,
    this.showInRow = false,
    this.prefix = "₹",
  });

  @override
  Widget build(BuildContext context) {
    var childs = [
      Text(
        label,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      Text(
        "$prefix$amount",
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.green,
        ),
      ),
    ];
    if (showInRow) {
      return Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: childs,
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: childs,
    );
  }
}
