import 'package:bachat_gat/common/common_index.dart';
import 'package:flutter/material.dart';

import '../../dao/dao_index.dart';
import '../../models/models_index.dart';
import '../member/member_details_card.dart';

class AddLoanPage extends StatefulWidget {
  final GroupMemberDetails groupMemberDetail;
  final String trxPeriod;
  final Group group;
  const AddLoanPage({
    super.key,
    required this.groupMemberDetail,
    required this.trxPeriod,
    required this.group,
  });

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
    groupDao = GroupsDao();
    groupMemberDetail = widget.groupMemberDetail;
    trxPeriod = widget.trxPeriod;
    group = widget.group;
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
      paidLoanAmount: 0,
      paidInterestAmount: 0,
      status: AppConstants.lsActive,
      loanDate: today,
      note: '',
      addedBy: '',
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
              await groupDao.addLoan(loanTrx);
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              MemberDetailsCard(groupMemberDetail),
              Table(
                children: [
                  TableRow(
                    children: [
                      buildLoanField(),
                      buildLoanInterestField(),
                    ],
                  )
                ],
              ),
              buildNoteField(),
            ],
          ),
        ),
      ),
    );
  }

  buildLoanField() {
    return CustomTextField(
      label: "Enter Loan Amount",
      field: "loanAmount",
      suffixIcon: const Icon(Icons.currency_rupee),
      value: "${(loanTrx.loanAmount ?? 0).toInt()}",
      onChange: (value) {
        loanTrx.loanAmount = double.tryParse(value) ?? 0;
      },
    );
  }

  buildLoanInterestField() {
    return CustomTextField(
      label: "Enter Loan Interest",
      field: "loanAmount",
      suffixIcon: const Icon(Icons.percent),
      value: "${(loanTrx.interestPercentage ?? 0).toInt()}",
      onChange: (value) {
        loanTrx.interestPercentage = double.tryParse(value) ?? 0;
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
