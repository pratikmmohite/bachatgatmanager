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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Report'),
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
                      totalBankBalance =
                          await dao.getBankBalanceTillToday(_group.id, date);
                      GroupBalanceSummary summary = await dao.getBalanceSummary(
                        _group.id.toString(),
                        date,
                        date,
                      );
                      String remaining = await dao.getPreviousYearAmount(
                          _group.id.toString(), date);
                      if (totalBankBalance != '0') {
                        setState(() {
                          totalBankBalance = totalBankBalance;
                          balanceSummary = summary;
                          previousRemaining = remaining;
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
                      itemCount: 8, // Number of rows
                      itemBuilder: (BuildContext context, int index) {
                        String label = '';
                        String value = '';

                        // Assign labels and values based on index
                        switch (index) {
                          case 0:
                            label = 'Previous Remaining:';
                            value = previousRemaining.toString();
                            break;
                          case 1:
                            label = 'Total Deposit:';
                            value = balanceSummary.totalDeposit.toString();
                            break;
                          case 2:
                            label = 'Total Shares:';
                            value = balanceSummary.totalShares.toString();
                            break;
                          case 3:
                            label = 'Total Penalty:';
                            value = balanceSummary.totalPenalty.toString();
                            break;
                          case 4:
                            label = 'Total Other Deposits:';
                            value = balanceSummary.otherDeposit.toString();
                            break;
                          case 5:
                            label = "Total Remaining Loan:";
                            value = balanceSummary.remainingLoan.toString();
                          case 6:
                            label = "Total Bank Balance till today:";
                            value = totalBankBalance.toString();
                          case 7:
                            label = "Total Expenditures";
                            value = balanceSummary.totalExpenditures.toString();
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
