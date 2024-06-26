/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/features/groups/pages/group/group_actions.dart';
import 'package:bachat_gat/locals/app_local_delegate.dart';
import 'package:flutter/material.dart';

import '../../dao/groups_dao.dart';
import '../../models/models_index.dart';
import 'group_add_page.dart';

class GroupsListPage extends StatefulWidget {
  const GroupsListPage({super.key});

  @override
  State<GroupsListPage> createState() => GroupsListPageState();
}

class GroupsListPageState extends State<GroupsListPage> {
  bool isLoading = false;
  List<Group> groups = [];
  late GroupsDao groupDao;

  Future<void> getGroups() async {
    groups = [];
    setState(() {
      isLoading = true;
    });
    try {
      groups = await groupDao.getGroups();
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
    getGroups();
    super.initState();
  }

  String getDateRangeStr(DateTime sdt, DateTime edt) {
    final shortMonthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    // Get the current month in short form as a string
    final sdtMonth = shortMonthNames[sdt.month - 1];
    final sdtYear = (sdt.year % 100).toString().padLeft(2, '0');

    final edtMonth = shortMonthNames[edt.month - 1];
    final edtYear = (edt.year % 100).toString().padLeft(2, '0');

    return "$sdtMonth $sdtYear - $edtMonth $edtYear";
  }

  void deleteGroup(Group group) async {
    groups = [];
    try {
      var d = await groupDao.deleteGroup(group);
      AppUtils.toast(context, "Group deleted successfully");
      getGroups();
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocal.of(context);
    return RefreshIndicator(
      onRefresh: () async {
        await getGroups();
      },
      child: groups.isEmpty
          ? Center(
              child: Text(
              local.mAddGroupMsg,
            ))
          : ListView.builder(
              itemBuilder: (ctx, index) {
                var group = groups[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.card_membership_rounded),
                    title: Text(
                      group.name,
                    ),
                    subtitle: Text(getDateRangeStr(group.sdt, group.edt)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ct) => GroupAddPage(
                                  group: group,
                                  key: ValueKey(group.id),
                                ),
                              ),
                            );
                            await getGroups();
                          },
                        ),
                        CustomDeleteIcon<Group>(
                          item: group,
                          content: Text("Group: ${group.name}"),
                          onAccept: (g) {
                            deleteGroup(g);
                          },
                        )
                      ],
                    ),
                    onTap: () async {
                      AppUtils.navigateTo(
                        context,
                        GroupActions(
                          key: ValueKey(group.id),
                          group: group,
                        ),
                      );
                    },
                  ),
                );
              },
              itemCount: groups.length,
            ),
    );
  }
}
