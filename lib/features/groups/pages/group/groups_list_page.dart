import 'package:flutter/material.dart';

import '../../dao/groups_dao.dart';
import '../../models/models_index.dart';
import '../member/members_list_page.dart';
import 'group_add_page.dart';
import 'group_details_screen.dart';

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
    groups = await groupDao.getGroups();
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

    return "$sdtMonth $sdtYear- $edtMonth $edtYear";
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await getGroups();
      },
      child: ListView.builder(
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
                    icon: const Icon(Icons.people),
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ct) => MembersList(
                            group,
                            key: ValueKey(group.id),
                          ),
                        ),
                      );
                      await getGroups();
                    },
                  ),
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
                ],
              ),
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ct) => GroupDetailsScreen(
                      key: ValueKey(group.id),
                      group: group,
                    ),
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
