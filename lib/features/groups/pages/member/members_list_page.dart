import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/locals/app_local_delegate.dart';
import 'package:flutter/material.dart';

import '../../dao/groups_dao.dart';
import '../../models/models_index.dart';
import 'add_member_page.dart';

class MembersList extends StatefulWidget {
  final Group group;
  const MembersList(this.group, {super.key});

  @override
  State<MembersList> createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  bool isLoading = false;
  List<GroupMember> members = [];
  late GroupsDao groupDao;
  late Group _group;

  Future<void> getMembers() async {
    members = [];
    setState(() {
      isLoading = true;
    });
    members = await groupDao.getMembers();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _group = widget.group;
    groupDao = GroupsDao();
    getMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocal.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(local.abMemberList),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ct) => MemberAddPage(_group),
            ),
          );
          await getMembers();
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await getMembers();
        },
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            var member = members[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(
                  member.name,
                ),
                subtitle: Text(member.mobileNo),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        await AppUtils.navigateTo(
                          context,
                          MemberAddPage(
                            _group,
                            groupMember: member,
                            key: ValueKey(member.id),
                          ),
                        );
                        await getMembers();
                      },
                    ),
                  ],
                ),
                onTap: () {},
              ),
            );
          },
          itemCount: members.length,
        ),
      ),
    );
  }
}
