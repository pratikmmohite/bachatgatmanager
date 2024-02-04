import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/features/groups/dao/dao_index.dart';
import 'package:bachat_gat/features/groups/pages/group/group_monthly_summary.dart';
import 'package:flutter/material.dart';

import '../../models/models_index.dart';
import 'group_details_screen.dart';

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
      groupSummary = await groupDao.getGroupSummary(filter);
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Group Actions"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  group.name,
                  style: TextStyle(fontSize: 20),
                ),
                const Divider(),
              ],
            ),
          ),
        ),
        body: Wrap(
          children: [
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
            )
          ],
        ));
  }
}
