import 'package:bachat_gat/common/constants.dart';
import 'package:bachat_gat/common/utils.dart';
import 'package:bachat_gat/common/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../dao/dao_index.dart';
import '../models/models_index.dart';

class AddMemberTransaction extends StatefulWidget {
  final GroupMemberDetails groupMemberDetail;
  final String trxPeriod;
  final Group group;
  const AddMemberTransaction({
    super.key,
    required this.groupMemberDetail,
    required this.trxPeriod,
    required this.group,
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
    var filter = MemberLoanFilter(group.id, trxPeriod);
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
    shareTrx = Transaction(
        memberId: groupMemberDetail.memberId,
        groupId: groupMemberDetail.groupId,
        trxType: AppConstants.ttShare,
        trxPeriod: trxPeriod,
        cr: 0,
        dr: 0,
        sourceId: "",
        sourceType: "",
        addedBy: "",
        trxDt: today,
        note: "");
    if (groupMemberDetail.paidShareAmount == 0) {
      shareTrx.cr = group.installmentAmtPerMonth;
    }

    loanTrx = Transaction(
        memberId: groupMemberDetail.memberId,
        groupId: groupMemberDetail.groupId,
        trxType: AppConstants.ttLoan,
        trxPeriod: trxPeriod,
        cr: 0,
        dr: 0,
        sourceId: "",
        sourceType: "",
        addedBy: "",
        trxDt: today,
        note: "");

    lateFeeTrx = Transaction(
        memberId: groupMemberDetail.memberId,
        groupId: groupMemberDetail.groupId,
        trxType: AppConstants.ttLateFee,
        trxPeriod: trxPeriod,
        cr: 0,
        dr: 0,
        sourceId: "",
        sourceType: "",
        addedBy: "",
        trxDt: today,
        note: "");
  }

  Widget buildMemberDetails(GroupMemberDetails groupMemberDetail) {
    return Card(
      child: ListTile(
        title: Text(groupMemberDetail.name),
        subtitle: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            CustomAmountChip(
              label: "Balance",
              amount: groupMemberDetail.balance,
            ),
            CustomAmountChip(
              label: "Share(+)",
              amount: groupMemberDetail.paidLoanAmount,
            ),
            CustomAmountChip(
              label: "LateFee(+)",
              amount: groupMemberDetail.paidLoanAmount,
            ),
            CustomAmountChip(
              label: "Loan(+)",
              amount: groupMemberDetail.paidLoanAmount,
            ),
            CustomAmountChip(
              label: "Remaining Loan(+)",
              amount: groupMemberDetail.pendingLoanAmount,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Record transaction"),
        actions: [Text(trxPeriod)],
      ),
      body: Column(
        children: [
          buildMemberDetails(groupMemberDetail),
          Table(
            children: [
              TableRow(
                children: [
                  buildShareField(),
                  buildLateFeeField(),
                ],
              ),
              TableRow(
                children: [
                  buildLoanOptions(),
                  buildLoanField(),
                ],
              ),
            ],
          ),
          ElevatedButton(
            child: const Text("Record Payment"),
            onPressed: () async {
              try {
                if (loanTrx.cr > 0 && loanTrx.sourceId.isEmpty) {
                  AppUtils.toast(context, "Please select loan");
                  return;
                }
                if (shareTrx.cr > 0) {
                  await groupDao.addTransaction(shareTrx);
                }
                if (loanTrx.cr > 0) {
                  await groupDao.addTransaction(loanTrx);
                }
                if (lateFeeTrx.cr > 0) {
                  await groupDao.addTransaction(lateFeeTrx);
                }
                AppUtils.toast(context, "Recorded transaction successfully");
                AppUtils.close(context);
              } catch (e) {
                AppUtils.toast(context, e.toString());
              }
            },
          )
        ],
      ),
    );
  }

  buildLoanField() {
    return CustomTextField(
      label: "Loan Amount",
      field: "loanAmount",
      value: "${(loanTrx.cr ?? 0).toInt()}",
      onChange: (value) {
        loanTrx.cr = double.tryParse(value) ?? 0;
      },
    );
  }

  buildLoanOptions() {
    return CustomDropDown(
      label: "Select loan",
      value: loanTrx.sourceId,
      onChange: (op) {
        loanTrx.sourceId = op.value;
      },
    );
  }

  buildLateFeeField() {
    return CustomTextField(
      label: "Late Fee",
      field: "lateFee",
      value: "${(lateFeeTrx.cr ?? 0).toInt()}",
      onChange: (value) {
        lateFeeTrx.cr = double.tryParse(value) ?? 0;
      },
    );
  }

  buildShareField() {
    return CustomTextField(
      label: "Share Amount",
      field: "shareAmt",
      value: "${(shareTrx.cr ?? 0).toInt()}",
      onChange: (value) {
        shareTrx.cr = double.tryParse(value) ?? 0;
      },
    );
  }
}
