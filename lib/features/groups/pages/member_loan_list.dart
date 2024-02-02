import 'package:bachat_gat/common/utils.dart';
import 'package:bachat_gat/common/widgets/custom_amount_chip.dart';
import 'package:bachat_gat/features/groups/pages/add_loan_page.dart';
import 'package:flutter/material.dart';

import '../dao/groups_dao.dart';
import '../models/models_index.dart';

class MembersLoanList extends StatefulWidget {
  final Group group;
  final GroupMemberDetails groupMemberDetails;
  const MembersLoanList(this.group,
      {super.key, required this.groupMemberDetails});

  @override
  State<MembersLoanList> createState() => _MembersLoanListState();
}

class _MembersLoanListState extends State<MembersLoanList> {
  bool isLoading = false;
  List<Loan> loans = [];
  late GroupsDao groupDao;
  late Group _group;
  late GroupMemberDetails groupMemberDetails;

  Future<void> getMemberLoans() async {
    loans = [];
    setState(() {
      isLoading = true;
    });
    loans = await groupDao.getMemberLoans(MemberLoanFilter(
        groupMemberDetails.groupId, groupMemberDetails.memberId));
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _group = widget.group;
    groupMemberDetails = widget.groupMemberDetails;
    groupDao = GroupsDao();
    getMemberLoans();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Members"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await AppUtils.navigateTo(
            context,
            AddLoanPage(
              groupMemberDetail: groupMemberDetails,
              trxPeriod: "",
              group: _group,
            ),
          );
          await getMemberLoans();
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await getMemberLoans();
        },
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            var loan = loans[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(
                  loan.note,
                ),
                subtitle: Wrap(
                  children: [
                    CustomAmountChip(
                      label: "Loan Amount",
                      amount: loan.loanAmount,
                    ),
                    CustomAmountChip(
                      label: "Remaining Loan",
                      amount: loan.remainingLoanAmount,
                    ),
                    CustomAmountChip(
                      label: "Interest (%)",
                      amount: loan.interestPercentage,
                    ),
                    CustomAmountChip(
                      label: "Remaining Interest",
                      amount: loan.remainingInterestAmount,
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: loans.length,
        ),
      ),
    );
  }
}
