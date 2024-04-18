/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:flutter/material.dart';

import '../../models/models_index.dart';

class BankDepositPage extends StatefulWidget {
  final Group group;
  const BankDepositPage({super.key, required this.group});

  @override
  State<BankDepositPage> createState() => _BankDepositPageState();
}

class _BankDepositPageState extends State<BankDepositPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bank Deposit"),
      ),
    );
  }
}
