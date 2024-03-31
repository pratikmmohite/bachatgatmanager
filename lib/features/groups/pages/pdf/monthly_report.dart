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
  late MonthlyBalanceSummary balanceSummary = MonthlyBalanceSummary(
    totalDeposit: 0.0,
    totalShares: 0.0,
    totalLoanInterest: 0.0,
    totalPenalty: 0.0,
    otherDeposit: 0.0,
    totalExpenditures: 0.0,
    remainingLoan: 0.0,
    paidLoan: 0.0,
    givenLoan: 0.0,
    peviousRemainigBalance: 0.0,
  );
  // double previousRemaining = 0.0;
  String str = "";
  String end = "";
  late String trxPeriod;
  late String selectYear;
  // late double paidLoan = 0.0;
  late double monthlydeposit = 0.0;

  DateTime _startDate = DateTime.now();
  String formatDt(DateTime dt) {
    return dt.toString().split(" ")[0];
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}";
  }

  late GroupsDao dao;
  late TextEditingController _textController =
      TextEditingController(text: "${formatDt(_startDate)}");
  @override
  void initState() {
    super.initState();
    _group = widget.group;
    // previousRemaining = 0.0;
    dao = GroupsDao();
    selectYear = '';
    totalBankBalance = '0.0';
    balanceSummary = MonthlyBalanceSummary(
      totalDeposit: 0.0,
      totalShares: 0.0,
      totalLoanInterest: 0.0,
      totalPenalty: 0.0,
      otherDeposit: 0.0,
      totalExpenditures: 0.0,
      remainingLoan: 0.0,
      paidLoan: 0.0,
      givenLoan: 0.0,
      peviousRemainigBalance: 0.0,
    );
    trxPeriod = _formatDate(_startDate);
    // balanceSummary = dao.getMonthlySummary(
    //   _group.id.toString(),
    //   _formatDate(_startDate),
    // ) as MonthlyBalanceSummary;
    // paidLoan = 0.0;
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
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: ElevatedButton.icon(
            //           icon: const Icon(Icons.calendar_today),
            //           onPressed: () async {
            //             var local = AppLocal.of(context);
            //             final DateTime? picked = await showDatePicker(
            //                 context: context,
            //                 initialDate: DateTime(
            //                     DateTime.now().year, DateTime.now().month, 1),
            //                 firstDate: DateTime(2000),
            //                 lastDate: DateTime(2101),
            //                 initialDatePickerMode: DatePickerMode.year,
            //                 initialEntryMode: DatePickerEntryMode.calendar);
            //             if (picked != null) {
            //               setState(() {
            //                 // trxPeriod = '${picked.year}-${picked.month}';
            //                 selectYear = local.getHumanTrxPeriod(picked);
            //                 selectedDate = true;
            //                 trxPeriod =
            //                     '${picked.year}-${picked.month.toString().padLeft(2, '0')}';
            //               });
            //             }
            //           },
            //           label: Text(
            //               !selectedDate ? "Select Date Range" : selectYear),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              margin: const EdgeInsets.all(4),
              // padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                ),
              ),

              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Select Date (YYYY-MM-DD)",
                  hintText: "Enter ${local.tfStartDate}",
                  filled: true,
                ),
                controller: _textController,
                onTap: () async {
                  DateTime? selectedRange = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2099),
                    initialEntryMode: DatePickerEntryMode.input,
                  );
                  if (selectedRange != null) {
                    setState(() {
                      _startDate = selectedRange;
                      trxPeriod = _formatDate(_startDate);
                      str = local.getHumanTrxPeriod(_startDate);
                      _textController.text = "${formatDt(selectedRange)}";
                    });
                  }
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.summarize),
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          Colors.blueGrey.shade50),
                    ),
                    onPressed: () async {
                      String date = trxPeriod;

                      totalBankBalance =
                          await dao.getBankBalanceTillToday(_group.id, date);
                      MonthlyBalanceSummary summary =
                          await dao.getMonthlySummary(
                        _group.id.toString(),
                        date,
                      );

                      // double remaining = await dao.getPreviousYearAmount(
                      //     _group.id.toString(), date);
                      // double paidLoan =
                      //     await dao.getPaidLoan(_group.id.toString(), date);

                      if (totalBankBalance != '0') {
                        setState(() {
                          totalBankBalance = totalBankBalance;
                          balanceSummary = summary;
                          // previousRemaining = remaining;
                          // paidLoan = paidLoan;
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
            const SizedBox(
              height: 15,
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
                      '${local.tfGroupName}:${_group.name.toString()}',
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
                      '${local.period} $selectYear ',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 14, // Number of rows
                      itemBuilder: (BuildContext context, int index) {
                        String label = '';
                        String value = '';
                        monthlydeposit = balanceSummary.totalDeposit +
                            balanceSummary.totalShares +
                            balanceSummary.paidLoan +
                            balanceSummary.totalLoanInterest +
                            balanceSummary.totalPenalty +
                            balanceSummary.otherDeposit;
                        // Assign labels and values based on index
                        switch (index) {
                          case 0:
                            label = local.lPrm;
                            value = balanceSummary.peviousRemainigBalance
                                .toString();
                            break;
                          case 1:
                            label = local.lDeposit;
                            value =
                                balanceSummary.totalDeposit.toStringAsFixed(2);
                            break;
                          case 2:
                            label = local.ltShares;
                            value =
                                balanceSummary.totalShares.toStringAsFixed(2);
                            break;
                          case 3:
                            label = local.lPaidLoan;
                            value = balanceSummary.paidLoan.toStringAsFixed(2);
                            break;
                          case 4:
                            label = local.lPaidInterest;
                            value = balanceSummary.totalLoanInterest
                                .toStringAsFixed(2);
                            break;
                          case 5:
                            label = local.lPenalty;
                            value =
                                balanceSummary.totalPenalty.toStringAsFixed(2);
                            break;
                          case 6:
                            label = local.ltOther;
                            value =
                                balanceSummary.otherDeposit.toStringAsFixed(2);
                            break;
                          case 7:
                            label = local.lmcr;
                            value = (balanceSummary.totalDeposit +
                                    balanceSummary.totalShares +
                                    balanceSummary.paidLoan +
                                    balanceSummary.totalLoanInterest +
                                    balanceSummary.totalPenalty +
                                    balanceSummary.otherDeposit)
                                .toStringAsFixed(2);

                            break;
                          case 8:
                            label = local.ltcr;
                            value = (monthlydeposit +
                                    balanceSummary.peviousRemainigBalance)
                                .toStringAsFixed(2);
                            break;

                          case 9:
                            label = local.lGivenLoan;
                            value = balanceSummary.givenLoan.toStringAsFixed(2);
                            break;
                          case 10:
                            label = local.ltExpenditures;
                            value = balanceSummary.totalExpenditures
                                .toStringAsFixed(2);
                            break;
                          case 11:
                            label = local.ltdr;
                            value = (balanceSummary.givenLoan +
                                    balanceSummary.totalExpenditures)
                                .toString();
                            break;
                          case 12:
                            label = local.lcb;
                            value = (monthlydeposit +
                                    balanceSummary.peviousRemainigBalance -
                                    balanceSummary.givenLoan -
                                    balanceSummary.totalExpenditures)
                                .toStringAsFixed(2);
                          case 13:
                            label = local.lTotal;
                            value = (monthlydeposit +
                                    balanceSummary.givenLoan +
                                    balanceSummary.totalExpenditures +
                                    balanceSummary.peviousRemainigBalance)
                                .toStringAsFixed(2);
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              label,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      (index == 8 || index == 11 || index == 12)
                                          ? Colors.red
                                          : Colors.black,
                                  backgroundColor: (index == 8 ||
                                          index == 11 ||
                                          index == 12)
                                      ? const Color.fromRGBO(221, 208, 200, 0.6)
                                      : Colors.white),
                              textAlign: TextAlign.justify,
                            ),
                            Text(
                              value,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      (index == 8 || index == 11 || index == 12)
                                          ? Colors.red
                                          : Colors.black,
                                  backgroundColor:
                                      (index == 8 || index == 11 || index == 12)
                                          ? Color.fromRGBO(221, 208, 200, 0.6)
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
