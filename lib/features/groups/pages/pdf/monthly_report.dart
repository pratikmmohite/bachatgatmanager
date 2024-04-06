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
  MonthlyBalanceSummary balanceSummary = MonthlyBalanceSummary(
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

  DateTime _startDate = DateTime.now();
  String formatDt(DateTime dt) {
    return dt.toString().split(" ")[0];
  }

  late CalculatedMonthlySummary monthlySummary = CalculatedMonthlySummary(
    MonthlyBalanceSummary(
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
    ),
  );

  late GroupsDao dao;
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}";
  }

  late TextEditingController _textController =
      TextEditingController(text: formatDt(_startDate));
  @override
  void initState() {
    super.initState();
    _group = widget.group;
    // previousRemaining = 0.0;
    dao = GroupsDao();

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
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocal.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(local.lMReport),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Divider(),
              Container(
                margin: const EdgeInsets.all(4),
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
                        _textController.text = formatDt(selectedRange);
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

                        CalculatedMonthlySummary sumary2 =
                            CalculatedMonthlySummary(summary);
                        if (totalBankBalance != '0') {
                          setState(() {
                            totalBankBalance = totalBankBalance;
                            balanceSummary = summary;
                            monthlySummary = sumary2;
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
                      label: const Text('Refresh Summary'),
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
                        '${local.period} : ${local.getHumanTrxPeriod(_startDate)} ',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(color: Colors.black),
                      SingleChildScrollView(
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(local.lPrm),
                                    Text(
                                      monthlySummary.previousRemainingBalance
                                          .toStringAsFixed(2),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(local.lDeposit),
                                    Text(
                                      monthlySummary.totalDeposit
                                          .toStringAsFixed(2),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(local.ltShares),
                                    Text(
                                      monthlySummary.totalShares
                                          .toStringAsFixed(2),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(local.lPaidLoan),
                                    Text(
                                      monthlySummary.paidLoan
                                          .toStringAsFixed(2),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(local.lPaidInterest),
                                    Text(
                                      monthlySummary.loanInterest
                                          .toStringAsFixed(2),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(local.lPenalty),
                                    Text(
                                      monthlySummary.totalPenalty
                                          .toStringAsFixed(2),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(local.ltOther),
                                    Text(
                                      monthlySummary.totalOtherDeposit
                                          .toStringAsFixed(2),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.yellowAccent,
                                    // Set a background color for highlighting
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        local.lmcr,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text(
                                        monthlySummary.monthlyCredit
                                            .toStringAsFixed(2),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        local.ltcr,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text(
                                        monthlySummary.totalCredit
                                            .toStringAsFixed(2),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(local.lGivenLoan + "(-)"),
                                    Text(
                                      monthlySummary.givenLoan
                                          .toStringAsFixed(2),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(local.ltExpenditures + "(-)"),
                                    Text(
                                      monthlySummary.totalExpenditures
                                          .toStringAsFixed(2),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        local.ltdr + "(-)",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text(
                                        monthlySummary.totalDebit
                                            .toStringAsFixed(2),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        local.lcb,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text(
                                        monthlySummary.monthlyClosingBalance
                                            .toStringAsFixed(2),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        " ${local.lTotal}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text(
                                        monthlySummary.total.toStringAsFixed(2),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
