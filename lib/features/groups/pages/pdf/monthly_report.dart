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
  DateTime selectedDate = DateTime.now();
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
  late String _selectMonth;
  String? _selectYear = "select year";
  final List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'June',
    'July',
    'Aug',
    'Sept',
    'Oct',
    'Nov',
    'Dec'
  ];
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String _formattDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();
    _group = widget.group;
    _selectMonth = months[0];
    _selectYear = 'Select Year';
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
        title: Text('Monthly Report'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.black,
                    ),
                  ),
                ),
                menuMaxHeight: 300,
                hint: const Text('Select Month'),
                icon: const Icon(Icons.calendar_month),
                iconSize: 20,
                value: _selectMonth,
                onChanged: (newValue) {
                  setState(() {
                    _selectMonth = newValue!;
                  });
                },
                items: months.map((valueItem) {
                  return DropdownMenuItem<String>(
                    value: valueItem,
                    child: Text(
                      valueItem,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 15),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      label: Text(_selectYear!),
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
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
                            _selectYear = picked.year.toString();
                          });
                        }
                      },
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
                      String _date =
                          '$_selectYear-${months.indexOf(_selectMonth) + 1}';
                      totalBankBalance =
                          await dao.getBankBalanceTillToday(_group.id, _date);
                      GroupBalanceSummary summary = await dao.getBalanceSummary(
                        _group.id.toString(),
                        _date,
                        _date,
                      );
                      String remaining = await dao.getPreviousYearAmount(
                          _group.id.toString(), _date);
                      if (totalBankBalance != '0') {
                        print("inside balance summary");
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
                      'Time Period $_selectMonth-$_selectYear ',
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
