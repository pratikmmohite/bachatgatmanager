import 'package:bachat_gat/locals/app_local_delegate.dart';
import 'package:flutter/material.dart';

import '../../dao/dao_index.dart';
import '../../models/models_index.dart';
import '../pdf/excel/excel_report.dart';

class YearlyReport extends StatefulWidget {
  const YearlyReport(this.group, {super.key});
  final Group group;

  @override
  State<YearlyReport> createState() => _YearlyReportState();
}

class _YearlyReportState extends State<YearlyReport> {
  late Group _group;
  late DateTime _startDate = DateTime.now();
  late DateTime _endDate = DateTime.now();
  bool isVisible = true;
  late String totalBankBalance;
  late GroupBalanceSummary balanceSummary;
  String str = '';
  String end = '';
  late String previousRemaining;
  String _formattDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();
    _group = widget.group;
    totalBankBalance = '0';
    previousRemaining = '0';

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
        title: const Text("Yearly Report"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            // Date Pickers for Start and End Dates
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.date_range),
                    onPressed: () async {
                      var local = AppLocal.of(context);
                      final DateTimeRange? picked = await showDateRangePicker(
                        context: context,
                        initialDateRange: DateTimeRange(
                          start: _startDate,
                          end: _endDate,
                        ),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                        initialEntryMode: DatePickerEntryMode.input,
                      );

                      if (picked != null) {
                        setState(() {
                          _startDate = picked.start;
                          _endDate = picked.end;
                          str = local.getHumanTrxPeriod(_startDate);
                          end = local.getHumanTrxPeriod(_endDate);
                        });
                      }
                    },
                    label:
                        Text(str == end ? "Select Date Range" : '$str to $end'),
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            // Download Button
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.download),
                    onPressed: () async {
                      ExcelExample.createAndSaveExcel(
                          _group.id.toString(),
                          _group.name.toString(),
                          _formattDate(_startDate),
                          _formattDate(_endDate));
                    },
                    label: const Text('Download Excel File'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.summarize),
                    onPressed: () async {
                      final dao = GroupsDao();
                      totalBankBalance = await dao.getBankBalanceTillToday(
                          _group.id, _formattDate(_endDate));
                      GroupBalanceSummary summary = await dao.getBalanceSummary(
                        _group.id.toString(),
                        _formattDate(_startDate),
                        _formattDate(_endDate),
                      );
                      String remaining = await dao.getPreviousYearAmount(
                          _group.id.toString(), _formattDate(_startDate));
                      if (totalBankBalance != '0') {
                        setState(() {
                          totalBankBalance = totalBankBalance;

                          balanceSummary = summary;
                          previousRemaining = remaining;
                          isVisible = !isVisible;
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
                    label: Text(
                        isVisible == false ? 'Fetch Summary' : 'Close Summary'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: isVisible,
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
                      'Time Period ${_formattDate(_startDate)} to ${_formattDate(_endDate)} ',
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
                            value = totalBankBalance;
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
