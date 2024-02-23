import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/features/groups/dao/dao_index.dart';
import 'package:bachat_gat/features/groups/pages/group/group_monthly_summary.dart';
import 'package:flutter/material.dart';

import '../../models/models_index.dart';
import '../member/members_list_page.dart';
import '../pdf/pdf_reports.dart';
import 'group_details_screen.dart';
import 'group_transaction_list.dart';

class GroupActions extends StatefulWidget {
  final Group group;
  const GroupActions({super.key, required this.group});
  @override
  State<GroupActions> createState() => _GroupActionsState();
}

class _GroupActionsState extends State<GroupActions> {
  late Group group;
  late GroupsDao groupDao;
  GroupTotal groupTotal = GroupTotal();
  bool isLoading = false;
  @override
  void initState() {
    group = widget.group;
    groupDao = GroupsDao();
    getGroupTotals();
    super.initState();
  }

  Future<void> getGroupTotals() async {
    groupTotal = GroupTotal();
    var filter = GroupTotalFilter(group.id);
    setState(() {
      isLoading = true;
    });
    try {
      groupTotal = await groupDao.getTotalBalances(filter);
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget buildSummary() {
    return Table(
      children: [
        TableRow(
          children: [
            const TableCell(
              child: Text("Balance"),
            ),
            TableCell(
              child: Text(groupTotal.balance.toStringAsFixed(2)),
            ),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
              child: Text("Total Saving"),
            ),
            TableCell(
              child: Text(groupTotal.totalSaving.toStringAsFixed(2)),
            ),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
              child: Text("Member Count"),
            ),
            TableCell(
              child: Text(groupTotal.memberCount.toStringAsFixed(2)),
            ),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
              child: Text("Member Portion"),
            ),
            TableCell(
              child: Text(groupTotal.perMemberShare.toStringAsFixed(2)),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(group.name),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : ListTile(title: buildSummary()),
              ),
              const Divider(),
              Card(
                child: ListTile(
                  title: const Text("Record Statement"),
                  leading: const Icon(Icons.money),
                  onTap: () async {
                    await AppUtils.navigateTo(
                      context,
                      GroupDetailsScreen(
                        key: ValueKey(group.id),
                        group: group,
                      ),
                    );
                    getGroupTotals();
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.summarize_outlined),
                  onTap: () {
                    AppUtils.navigateTo(
                      context,
                      GroupMonthlySummary(
                        group: group,
                      ),
                    );
                  },
                  title: const Text("Group Summary"),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.account_balance),
                  onTap: () async {
                    await AppUtils.navigateTo(
                      context,
                      GroupTransactionList(
                        group: group,
                      ),
                    );
                    getGroupTotals();
                  },
                  title: const Text("Group Transactions"),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.people),
                  onTap: () {
                    AppUtils.navigateTo(
                      context,
                      MembersList(
                        group,
                      ),
                    );
                  },
                  title: const Text("Member List"),
                ),
              ),
              Card(
                  child: ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PdfReports(
                              group,
                            )),
                  );
                },
                title: const Text("Reports"),
              )),
            ],
          ),
        ));
  }
}
