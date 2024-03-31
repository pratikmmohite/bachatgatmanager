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
  bool isVisible = false;
  late String totalBankBalance;
  double totalcredit = 0.0;
  late GroupBalanceSummary balanceSummary;
  String str = '';
  String end = '';
  DateTimeRange dtchange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());
  late String previousRemaining;
  String _formattDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}";
  }

  String formatDt(DateTime dt) {
    return dt.toString().split(" ")[0];
  }

  late TextEditingController _textController;
  @override
  void initState() {
    super.initState();
    _group = widget.group;
    totalBankBalance = '0';
    previousRemaining = '0';

    balanceSummary = GroupBalanceSummary(
      deposit: 0.0,
      shares: 0.0,
      loanInterest: 0.0,
      penalty: 0.0,
      otherDeposit: 0.0,
      expenditures: 0.0,
      remainingLoan: 0.0,
      paidLoan: 0.0,
      previousRemaining: 0.0,
      givenLoan: 0.0,
    );
    _textController = TextEditingController(
        text: "${formatDt(_startDate)} to ${formatDt(_endDate)}");
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocal.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(local.lYReport),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            // Date Pickers for Start and End Dates
            // Row(
            //   children: [
            //     Expanded(
            //       child: ElevatedButton.icon(
            //         icon: const Icon(Icons.date_range),
            //         onPressed: () async {
            //           var local = AppLocal.of(context);
            //           final DateTimeRange? picked = await showDateRangePicker(
            //             context: context,
            //             initialDateRange: DateTimeRange(
            //               start: _startDate,
            //               end: _endDate,
            //             ),
            //             firstDate: DateTime(2000),
            //             lastDate: DateTime(2101),
            //             initialEntryMode: DatePickerEntryMode.input,
            //           );
            //
            //           if (picked != null) {
            //             setState(() {
            //               _startDate = picked.start;
            //               _endDate = picked.end;
            //               str = local.getHumanTrxPeriod(_startDate);
            //               end = local.getHumanTrxPeriod(_endDate);
            //             });
            //           }
            //         },
            //         label:
            //             Text(str == end ? "Select Date Range" : '$str to $end'),
            //       ),
            //     )
            //   ],
            // ),
            Container(
              margin: const EdgeInsets.all(2),
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Select Date (YYYY-MM-DD) to (YYYY-MM-DD)",
                  hintText: "Enter ${local.tfStartDate}",
                  filled: true,
                ),
                controller: _textController,
                onTap: () async {
                  var dt = DateTimeRange(start: _startDate, end: _endDate);
                  DateTimeRange? selectedRange = await showDateRangePicker(
                    context: context,
                    initialDateRange: dt,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2099),
                    initialEntryMode: DatePickerEntryMode.input,
                  );
                  if (selectedRange != null) {
                    setState(
                      () {
                        _startDate = selectedRange.start;
                        _endDate = selectedRange.end;
                        str = local.getHumanTrxPeriod(_startDate);
                        end = local.getHumanTrxPeriod(_endDate);
                        _textController.text =
                            "${formatDt(selectedRange.start)} to ${formatDt(selectedRange.end)}";
                        dtchange = selectedRange;
                      },
                    );
                  }
                },
              ),
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
                    label: const Text('Download Excel'),
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
                      double remaining = await dao.getPreviousYearAmount(
                          _group.id.toString(), _formattDate(_startDate));
                      if (totalBankBalance != '0') {
                        setState(() {
                          totalBankBalance = totalBankBalance;

                          balanceSummary = summary;
                          previousRemaining = remaining.toStringAsFixed(2);
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
                    label: Text(isVisible == false
                        ? 'Fetch Summary'
                        : 'Refresh Summary'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                      'Time Period ${_formattDate(_startDate)} to ${_formattDate(_endDate)} ',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 13, // Number of rows
                      itemBuilder: (BuildContext context, int index) {
                        String label = '';
                        String value = '';

                        // Assign labels and values based on index
                        switch (index) {
                          case 0:
                            label = local.lPrm;
                            value = balanceSummary.previousRemaining
                                .toStringAsFixed(2);
                            break;
                          case 1:
                            label = local.lDeposit;
                            value = balanceSummary.deposit.toStringAsFixed(2);
                            break;
                          case 2:
                            label = local.ltShares;
                            value = balanceSummary.shares.toStringAsFixed(2);
                            break;
                          case 3:
                            label = local.lPaidInterest;
                            value =
                                balanceSummary.loanInterest.toStringAsFixed(2);
                            break;
                          case 4:
                            label = local.lPaidLoan;
                            value = balanceSummary.paidLoan.toStringAsFixed(2);
                            break;
                          case 5:
                            label = local.lPenalty;
                            value = balanceSummary.penalty.toString();
                            break;
                          case 6:
                            label = local.ltOther;
                            value = balanceSummary.otherDeposit.toString();
                            break;
                          case 7:
                            label = local.ltcr;
                            value = (balanceSummary.previousRemaining +
                                    balanceSummary.deposit +
                                    balanceSummary.loanInterest +
                                    balanceSummary.penalty +
                                    balanceSummary.otherDeposit +
                                    balanceSummary.shares +
                                    balanceSummary.paidLoan)
                                .toStringAsFixed(2);
                            totalcredit = balanceSummary.previousRemaining +
                                balanceSummary.deposit +
                                balanceSummary.loanInterest +
                                balanceSummary.penalty +
                                balanceSummary.otherDeposit +
                                balanceSummary.shares +
                                balanceSummary.paidLoan;
                            break;
                          case 8:
                            label = local.ltExpenditures;
                            value =
                                balanceSummary.expenditures.toStringAsFixed(2);
                          case 9:
                            label = local.lRmLoan;
                            value =
                                balanceSummary.remainingLoan.toStringAsFixed(2);
                          case 10:
                            label = local.ltBankBalance;
                            value = balanceSummary.expenditures.toString();
                            break;
                          case 11:
                            label = local.lGivenLoan;
                            value = balanceSummary.givenLoan.toStringAsFixed(2);
                            break;
                          case 12:
                            label = local.lcrdr;
                            value = (totalcredit -
                                    balanceSummary.givenLoan -
                                    balanceSummary.expenditures)
                                .toStringAsFixed(2);
                            break;
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              label,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: (index == 7 || index == 12)
                                      ? Colors.red
                                      : Colors.black,
                                  backgroundColor: (index == 7 || index == 12)
                                      ? const Color.fromRGBO(221, 208, 200, 0.6)
                                      : Colors.white),
                              textAlign: TextAlign.justify,
                            ),
                            Text(
                              value,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: (index == 7 || index == 12)
                                      ? Colors.red
                                      : Colors.black,
                                  backgroundColor: (index == 7 || index == 12)
                                      ? const Color.fromRGBO(221, 208, 200, 0.6)
                                      : Colors.white),
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
