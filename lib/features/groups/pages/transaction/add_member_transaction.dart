import 'package:bachat_gat/common/common_index.dart';
import 'package:flutter/material.dart';

import '../../dao/dao_index.dart';
import '../../models/models_index.dart';
import '../member/member_details_card.dart';

class AddMemberTransaction extends StatefulWidget {
  final GroupMemberDetails groupMemberDetail;
  final String trxPeriod;
  final Group group;
  final String mode;
  const AddMemberTransaction({
    super.key,
    required this.groupMemberDetail,
    required this.trxPeriod,
    required this.group,
    this.mode = AppConstants.tmPayment,
  });

  @override
  State<AddMemberTransaction> createState() => _AddMemberTransactionState();
}

class _AddMemberTransactionState extends State<AddMemberTransaction> {
  late GroupMemberDetails groupMemberDetail;
  late Group group;
  late GroupsDao groupDao;
  String trxPeriod = "";
  List<Loan> memberLoans = [];
  bool isLoading = false;
  late Transaction shareTrx;
  late Transaction loanTrx;
  late Transaction loanInterestTrx;
  late Transaction lateFeeTrx;

  @override
  void initState() {
    groupMemberDetail = widget.groupMemberDetail;
    trxPeriod = widget.trxPeriod;
    group = widget.group;
    groupDao = GroupsDao();
    prepareRequests();
    getLoans();
    super.initState();
  }

  Future<void> getLoans() async {
    memberLoans = [];
    var filter = MemberLoanFilter(group.id, groupMemberDetail.memberId);
    filter.status = AppConstants.lsActive;
    setState(() {
      isLoading = true;
    });
    try {
      memberLoans = await groupDao.getMemberLoans(filter);
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  void prepareRequests() {
    var today = DateTime.now();
    shareTrx = Transaction.withDefault(
      memberId: groupMemberDetail.memberId,
      groupId: groupMemberDetail.groupId,
      trxType: AppConstants.ttShare,
      trxPeriod: trxPeriod,
    );
    if (groupMemberDetail.paidShareAmount == 0) {
      shareTrx.cr = group.installmentAmtPerMonth;
    }
    loanTrx = Transaction.withDefault(
      memberId: groupMemberDetail.memberId,
      groupId: groupMemberDetail.groupId,
      trxType: AppConstants.ttLoan,
      trxPeriod: trxPeriod,
      trxDt: today,
    );
    loanInterestTrx = Transaction.withDefault(
      memberId: groupMemberDetail.memberId,
      groupId: groupMemberDetail.groupId,
      trxType: AppConstants.ttLoanInterest,
      trxPeriod: trxPeriod,
      trxDt: today,
    );
    lateFeeTrx = Transaction.withDefault(
      memberId: groupMemberDetail.memberId,
      groupId: groupMemberDetail.groupId,
      trxType: AppConstants.ttLateFee,
      trxPeriod: trxPeriod,
    );
  }

  Widget getFields() {
    switch (widget.mode) {
      case AppConstants.tmLoan:
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          children: [
            buildLoanOptions(),
            Table(
              children: [
                TableRow(
                  children: [
                    buildLoanField(),
                    buildLoanInterestField(),
                  ],
                ),
              ],
            ),
          ],
        );
        break;
      case AppConstants.tmPayment:
      default:
        return Table(
          children: [
            TableRow(
              children: [
                buildShareField(),
                buildLateFeeField(),
              ],
            )
          ],
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Record transaction"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(trxPeriod),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: recordTransaction,
        label: Text("Record ${widget.mode}"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            MemberDetailsCard(groupMemberDetail),
            getFields(),
          ],
        ),
      ),
    );
  }

  bool isValid() {
    switch (widget.mode) {
      case AppConstants.tmLoan:
        if (loanTrx.sourceId.isEmpty) {
          AppUtils.toast(context, "Please select loan");
          return false;
        }
        if (loanTrx.cr == 0) {
          AppUtils.toast(context, "Please enter loan amount");
          return false;
        }
        break;
      case AppConstants.tmPayment:
        if (shareTrx.cr == 0) {
          AppUtils.toast(context, "Please enter share amount");
          return false;
        }
        break;
    }
    return true;
  }

  void recordTransaction() async {
    try {
      if (!isValid()) {
        return;
      }
      switch (widget.mode) {
        case AppConstants.tmLoan:
          if (loanTrx.cr > 0) {
            await groupDao.addTransaction(loanTrx);
          }
          if (loanInterestTrx.cr > 0) {
            await groupDao.addTransaction(loanInterestTrx);
          }
          AppUtils.toast(context, "Recorded loan payment successfully");
          AppUtils.close(context);
          break;
        case AppConstants.tmPayment:
          if (shareTrx.cr > 0) {
            await groupDao.addTransaction(shareTrx);
          }
          if (lateFeeTrx.cr > 0) {
            await groupDao.addTransaction(lateFeeTrx);
          }
          AppUtils.toast(context, "Recorded share payment successfully");
          AppUtils.close(context);
          break;
      }
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
  }

  buildLoanField() {
    return CustomTextField(
      label: "Loan Amount",
      field: "loanAmount",
      suffixIcon: const Icon(Icons.currency_rupee),
      value: "${(loanTrx.cr ?? 0).toInt()}",
      onChange: (value) {
        loanTrx.cr = double.tryParse(value) ?? 0;
      },
    );
  }

  buildLoanOptions() {
    var options = memberLoans
        .map(
          (e) => CustomDropDownOption<Loan>(e.toString(), e.id, e),
        )
        .toList();
    return CustomDropDown<Loan>(
      label: "Select loan to pay",
      value: loanTrx.sourceId,
      options: options,
      onChange: (op) {
        var remainingLoan = op.valueObj.loanAmount - op.valueObj.paidLoanAmount;
        var interest = op.valueObj.interestPercentage;
        setState(() {
          loanTrx.sourceId = op.value;
          loanTrx.cr = remainingLoan;
          loanInterestTrx.cr = (remainingLoan * interest ~/ 100).toDouble();
        });
      },
    );
  }

  buildLateFeeField() {
    return CustomTextField(
      label: "Late Fee",
      field: "lateFee",
      value: "${(lateFeeTrx.cr ?? 0).toInt()}",
      suffixIcon: const Icon(Icons.currency_rupee),
      onChange: (value) {
        lateFeeTrx.cr = double.tryParse(value) ?? 0;
      },
    );
  }

  buildLoanInterestField() {
    return CustomTextField(
      label: "Loan Interest",
      field: "lateFee",
      suffixIcon: const Icon(Icons.currency_rupee),
      value: "${(loanInterestTrx.cr ?? 0).toInt()}",
      onChange: (value) {
        loanInterestTrx.cr = double.tryParse(value) ?? 0;
      },
    );
  }

  buildShareField() {
    return CustomTextField(
      label: "Share Amount",
      field: "shareAmt",
      suffixIcon: const Icon(Icons.currency_rupee),
      value: "${(shareTrx.cr ?? 0).toInt()}",
      onChange: (value) {
        shareTrx.cr = double.tryParse(value) ?? 0;
      },
    );
  }
}
