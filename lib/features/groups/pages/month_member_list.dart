import 'package:bachat_gat/common/utils.dart';
import 'package:bachat_gat/common/widgets/widgets.dart';
import 'package:bachat_gat/features/groups/pages/add_member_transaction.dart';
import 'package:flutter/material.dart';

import '../dao/dao_index.dart';
import '../models/models_index.dart';

class MonthMemberList extends StatefulWidget {
  final String trxPeriod;
  final Group group;
  const MonthMemberList({
    super.key,
    required this.trxPeriod,
    required this.group,
  });

  @override
  State<MonthMemberList> createState() => _MonthMemberListState();
}

class _MonthMemberListState extends State<MonthMemberList> {
  late Group group;
  late String trxPeriod;
  List<GroupMemberDetails> memberDetails = [];
  late GroupsDao groupDao;
  bool isLoading = false;
  Future<void> getGroups() async {
    memberDetails = [];
    var filter = MemberBalanceFilter(group.id, trxPeriod);
    setState(() {
      isLoading = true;
    });
    try {
      memberDetails = await groupDao.getGroupMembersWithBalance(filter);
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    groupDao = GroupsDao();
    group = widget.group;
    trxPeriod = widget.trxPeriod;
    getGroups();
    super.initState();
  }

  Widget buildMemberDetails(GroupMemberDetails groupMemberDetail) {
    var mq = MediaQuery.of(context);
    var screenWidth = mq.size.width / 3 - 2;
    return Card(
      child: ListTile(
        onTap: () {
          AppUtils.navigateTo(
            context,
            AddMemberTransaction(
                groupMemberDetail: groupMemberDetail,
                trxPeriod: trxPeriod,
                group: group),
          );
        },
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
              label: "Remaining Loan(-)",
              amount: groupMemberDetail.pendingLoanAmount,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await getGroups();
      },
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: memberDetails.length,
              itemBuilder: (buildContext, index) {
                return buildMemberDetails(memberDetails[index]);
              },
            ),
    );
  }
}
