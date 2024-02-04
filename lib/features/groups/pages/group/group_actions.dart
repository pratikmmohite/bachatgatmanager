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
        ),
        body: ListView(
          children: [
            ListTile(
              title: const Text("Record Statement"),
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
            ListTile(
              onTap: () {
                AppUtils.navigateTo(
                  context,
                  GroupMonthlySummary(
                    group: group,
                  ),
                );
              },
              title: const Text("Group Summary"),
            )
          ],
        ));
  }
}
