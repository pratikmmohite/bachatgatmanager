import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/features/groups/dao/dao_index.dart';
import 'package:bachat_gat/features/groups/pages/group/group_monthly_summary.dart';
import 'package:flutter/material.dart';

import '../../models/models_index.dart';
import '../member/members_list_page.dart';
import 'group_details_screen.dart';
import 'group_summary_card.dart';

class GroupActions extends StatefulWidget {
  final Group group;
  const GroupActions({super.key, required this.group});
  @override
  State<GroupActions> createState() => _GroupActionsState();
}

class _GroupActionsState extends State<GroupActions> {
  late Group group;
  late GroupsDao groupDao;
  List<GroupSummary> groupSummary = [];
  bool isLoading = false;
  @override
  void initState() {
    group = widget.group;
    groupDao = GroupsDao();
    getGroupSummary();
    super.initState();
  }

  Future<void> getGroupSummary() async {
    groupSummary = [];
    var filter = GroupSummaryFilter(group.id);
    filter.edt = group.edt;
    setState(() {
      isLoading = true;
    });
    try {
      groupSummary = await groupDao.getBalances(filter);
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget buildSummary() {
    return GroupSummaryCard(
      summary: groupSummary,
      showCombined: true,
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
              if (groupSummary.isNotEmpty)
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : ListTile(
                          title: const Text(
                            "Total",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: buildSummary(),
                        ),
                ),
              const Divider(),
              Card(
                child: ListTile(
                  title: const Text("Record Statement"),
                  leading: const Icon(Icons.money),
                  onTap: () {
                    AppUtils.navigateTo(
                      context,
                      GroupDetailsScreen(
                        key: ValueKey(group.id),
                        group: group,
                      ),
                    );
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
              // Card(
              //   child: ListTile(
              //     leading: const Icon(Icons.account_balance),
              //     onTap: () {
              //       AppUtils.navigateTo(
              //         context,
              //         BankDepositPage(
              //           group: group,
              //         ),
              //       );
              //     },
              //     title: const Text("Bank Deposits"),
              //   ),
              // ),
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
            ],
          ),
        ));
  }
}
