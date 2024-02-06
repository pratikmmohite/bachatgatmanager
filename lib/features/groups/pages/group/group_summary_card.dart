import 'package:flutter/material.dart';

import '../../models/models_index.dart';

class GroupSummaryCard extends StatefulWidget {
  final List<GroupSummary> summary;
  final bool showCombined;
  const GroupSummaryCard(
      {super.key, required this.summary, this.showCombined = false});

  @override
  State<GroupSummaryCard> createState() => _GroupSummaryCardState();
}

class _GroupSummaryCardState extends State<GroupSummaryCard> {
  List<GroupSummary> summary = [];
  Map<String, double> creditSummaryMap = {};
  Map<String, double> totalSummaryMap = {};
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
    totalSummaryMap = {};

    for (var gs in summary) {
      var trxType = gs.trxType;
      if (widget.showCombined) {
        if (!totalSummaryMap.containsKey(trxType)) {
          totalSummaryMap[trxType] = 0;
        }
        var total = gs.totalCr - gs.totalDr;
        totalSummaryMap[trxType] = (totalSummaryMap[trxType] ?? 0) + total;
      } else {
        if (gs.totalCr > 0) {
          if (!creditSummaryMap.containsKey(trxType)) {
            creditSummaryMap[trxType] = 0;
          }
          creditSummaryMap[trxType] =
              (creditSummaryMap[trxType] ?? 0) + gs.totalCr;
        }
        if (gs.totalDr > 0) {
          if (!debitSummaryMap.containsKey(trxType)) {
            debitSummaryMap[trxType] = 0;
          }
          debitSummaryMap[trxType] =
              (debitSummaryMap[trxType] ?? 0) + gs.totalDr;
        }
      }
    }
  }

  Table buildSummary() {
    List<TableRow> tableRows = [];
    if (widget.showCombined) {
      totalSummaryMap.forEach((key, value) {
        tableRows.add(TableRow(children: [
          TableCell(child: Text(key)),
          TableCell(
            child: Text(
              value.toStringAsFixed(2),
            ),
          )
        ]));
      });
    } else {
      creditSummaryMap.forEach((key, value) {
        tableRows.add(TableRow(children: [
          TableCell(child: Text(key)),
          TableCell(
            child: Text(
              "+${value.toStringAsFixed(2)}",
            ),
          )
        ]));
      });
      debitSummaryMap.forEach((key, value) {
        tableRows.add(TableRow(children: [
          TableCell(child: Text(key)),
          TableCell(
              child: Text(
            "-${value.toStringAsFixed(2)}",
          ))
        ]));
      });
    }
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
