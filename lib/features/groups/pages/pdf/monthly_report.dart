import 'package:bachat_gat/locals/app_local_delegate.dart';
import 'package:flutter/material.dart';

import '../../dao/dao_index.dart';
import '../../models/models_index.dart';

class MonthlyReport extends StatefulWidget {
  const MonthlyReport(this.group, {super.key});
  final Group group;

  @override
  State<MonthlyReport> createState() => _MonthlyReportState();
}

class _MonthlyReportState extends State<MonthlyReport> {
  late Group _group;
  bool selectedDate = false;
  String? totalBankBalance = '0.0';
  late GroupBalanceSummary balanceSummary = GroupBalanceSummary(
    totalDeposit: 0.0,
    totalShares: 0.0,
    totalLoanInterest: 0.0,
    totalPenalty: 0.0,
    otherDeposit: 0.0,
    totalExpenditures: 0.0,
    remainingLoan: 0.0,
  );
  String? previousRemaining;

  late String trxPeriod;
  late String selectYear;
  late double paidLoan = 0.0;

  @override
  void initState() {
    super.initState();
    _group = widget.group;

    selectYear = '';
    totalBankBalance = '0.0';
    previousRemaining = '0.0';
    balanceSummary = GroupBalanceSummary(
      totalDeposit: 0.0,
      totalShares: 0.0,
      totalLoanInterest: 0.0,
      totalPenalty: 0.0,
      otherDeposit: 0.0,
      totalExpenditures: 0.0,
      remainingLoan: 0.0,
    );
    paidLoan = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocal.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(local.lMReport),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        var local = AppLocal.of(context);
                        final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(
                                DateTime.now().year, DateTime.now().month, 1),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                            initialDatePickerMode: DatePickerMode.year,
                            initialEntryMode: DatePickerEntryMode.calendar);
                        if (picked != null) {
                          setState(() {
                            trxPeriod = '${picked.year}-${picked.month}';
                            selectYear = local.getHumanTrxPeriod(picked);
                            selectedDate = true;
                            trxPeriod =
                                '${picked.year}-${picked.month.toString().padLeft(2, '0')}';
                          });
                        }
                      },
                      label: Text(!selectedDate ? "Select Date" : selectYear),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.summarize),
                    onPressed: () async {
                      final dao = GroupsDao();
                      String date = trxPeriod;
                      print(date);
                      totalBankBalance =
                          await dao.getBankBalanceTillToday(_group.id, date);
                      GroupBalanceSummary summary = await dao.getMonthlySummary(
                        _group.id.toString(),
                        date,
                      );
                      print(summary.totalShares);
                      String remaining = await dao.getPreviousYearAmount(
                          _group.id.toString(), date);
                      double _paidLoan =
                          await dao.getPaidLoan(_group.id.toString(), date);
                      print(_paidLoan);
                      if (totalBankBalance != '0') {
                        setState(() {
                          totalBankBalance = totalBankBalance;
                          balanceSummary = summary;
                          previousRemaining = remaining;
                          paidLoan = _paidLoan;
                          // isVisible = !isVisible;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "There are no transaction between this period for the member please change the time period",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    label: const Text('Get BalanceSheet Summary'),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: true,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      'Group Name:${_group.name.toString()}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Time Period $selectYear ',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 10, // Number of rows
                      itemBuilder: (BuildContext context, int index) {
                        String label = '';
                        String value = '';

                        // Assign labels and values based on index
                        switch (index) {
                          case 0:
                            label = local.lPrm;
                            value = previousRemaining.toString();
                            break;
                          case 1:
                            label = local.lDeposit;
                            value = balanceSummary.totalDeposit.toString();
                            break;
                          case 2:
                            label = local.ltShares;
                            value = balanceSummary.totalShares.toString();
                            break;
                          case 3:
                            label = local.lPenalty;
                            value = balanceSummary.totalPenalty.toString();
                            break;
                          case 4:
                            label = local.ltOther;
                            value = balanceSummary.otherDeposit.toString();
                            break;
                          case 5:
                            label = local.lPaidLoan;
                            value = paidLoan.toString();
                            break;
                          case 6:
                            label = local.lRmLoan;
                            value = balanceSummary.remainingLoan.toString();
                          case 7:
                            label = local.ltBankBalance;
                            value = totalBankBalance.toString();
                          case 8:
                            label = local.ltExpenditures;
                            value = balanceSummary.totalExpenditures.toString();
                            break;
                          case 9:
                            label = local.ltGathered;
                            value = (balanceSummary.otherDeposit +
                                    balanceSummary.totalPenalty +
                                    balanceSummary.totalShares +
                                    balanceSummary.totalDeposit +
                                    paidLoan)
                                .toStringAsFixed(2);
                            break;
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              label,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.justify,
                            ),
                            Text(
                              value,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
