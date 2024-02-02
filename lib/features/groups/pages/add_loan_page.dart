import 'package:bachat_gat/common/constants.dart';
import 'package:bachat_gat/common/utils.dart';
import 'package:bachat_gat/common/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../dao/dao_index.dart';
import '../models/models_index.dart';
import 'member_details_card.dart';

class AddLoanPage extends StatefulWidget {
  final GroupMemberDetails groupMemberDetail;
  final String trxPeriod;
  final Group group;
  const AddLoanPage(
      {super.key,
      required this.groupMemberDetail,
      required this.trxPeriod,
      required this.group});

  @override
  State<AddLoanPage> createState() => _AddLoanPageState();
}

class _AddLoanPageState extends State<AddLoanPage> {
  late GroupMemberDetails groupMemberDetail;
  late Group group;
  late GroupsDao groupDao;
  String trxPeriod = "";
  List<Loan> memberLoans = [];
  bool isLoading = false;
  late Loan loanTrx;

  @override
  void initState() {
    groupMemberDetail = widget.groupMemberDetail;
    trxPeriod = widget.trxPeriod;
    group = widget.group;
    groupDao = GroupsDao();
    prepareRequests();
    super.initState();
  }

  void prepareRequests() {
    var today = DateTime.now();
    loanTrx = Loan(
      memberId: groupMemberDetail.memberId,
      groupId: groupMemberDetail.groupId,
      loanAmount: 0,
      interestPercentage: group.loanInterestPercentPerMonth,
      remainingLoanAmount: 0,
      remainingInterestAmount: 0,
      status: AppConstants.lsActive,
      loanDate: today,
      note: "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Loan"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(trxPeriod),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          try {
            if (loanTrx.loanAmount > 0) {
              loanTrx.remainingLoanAmount = loanTrx.remainingLoanAmount;
              groupDao.addLoan(loanTrx);
              AppUtils.toast(context, "Recorded loan successfully");
              AppUtils.close(context);
              return;
            }
          } catch (e) {
            AppUtils.toast(context, e.toString());
          }
        },
        label: const Text("Give loan"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            MemberDetailsCard(groupMemberDetail),
            buildLoanField(),
            buildNoteField(),
          ],
        ),
      ),
    );
  }

  buildLoanField() {
    return CustomTextField(
      label: "Enter Loan Amount",
      field: "loanAmount",
      value: "${(loanTrx.loanAmount ?? 0).toInt()}",
      onChange: (value) {
        loanTrx.loanAmount = double.tryParse(value) ?? 0;
      },
    );
  }

  buildNoteField() {
    return CustomTextField(
      label: "Enter Note",
      field: "note",
      value: loanTrx.note,
      onChange: (value) {
        loanTrx.note = value;
      },
    );
  }
}
