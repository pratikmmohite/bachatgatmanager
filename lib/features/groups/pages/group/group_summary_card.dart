import 'package:flutter/material.dart';

import '../../models/models_index.dart';

class GroupSummaryCard extends StatefulWidget {
  final List<GroupSummary> summary;
  const GroupSummaryCard({super.key, required this.summary});

  @override
  State<GroupSummaryCard> createState() => _GroupSummaryCardState();
}

class _GroupSummaryCardState extends State<GroupSummaryCard> {
  List<GroupSummary> summary = [];
  Map<String, double> creditSummaryMap = {};
  Map<String, double> debitSummaryMap = {};
  @override
  void initState() {
    summary = widget.summary;
    calculateSummary();
    super.initState();
  }

  void calculateSummary() {
    creditSummaryMap = {};
    debitSummaryMap = {};
    for (var gs in summary) {
      if (gs.totalCr > 0) {
        if (!creditSummaryMap.containsKey(gs.trxType)) {
          creditSummaryMap[gs.trxType] = 0;
        }

        creditSummaryMap[gs.trxType] =
            (creditSummaryMap[gs.trxType] ?? 0) + gs.totalCr;
      }
      if (gs.totalDr > 0) {
        if (!debitSummaryMap.containsKey(gs.trxType)) {
          debitSummaryMap[gs.trxType] = 0;
        }
        debitSummaryMap[gs.trxType] =
            (debitSummaryMap[gs.trxType] ?? 0) + gs.totalDr;
      }
    }
  }

  Widget buildSummary() {
    List<TableRow> tableRows = [];
    creditSummaryMap.forEach((key, value) {
      tableRows.add(TableRow(children: [
        TableCell(child: Text("Total $key")),
        TableCell(
            child: Text(
          value.toStringAsFixed(2),
        ))
      ]));
    });

    debitSummaryMap.forEach((key, value) {
      tableRows.add(TableRow(children: [
        TableCell(child: Text("Total $key")),
        TableCell(
            child: Text(
          value.toStringAsFixed(2),
        ))
      ]));
    });
    return Table(
      children: tableRows,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: buildSummary(),
    );
  }
}
