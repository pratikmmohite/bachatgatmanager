import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/locals/app_local_delegate.dart';
import 'package:flutter/material.dart';

import '../../dao/groups_dao.dart';
import '../../models/models_index.dart';
import 'add_member_page.dart';
import 'member_transactions_list.dart';

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
    var filter = MemberFilter(_group.id);
    setState(() {
      isLoading = true;
    });
    try {
      members = await groupDao.getMembers(filter);
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
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

  handleShowTransactionListClick(GroupMember member) async {
    GroupMemberDetails m = GroupMemberDetails();
    m.name = member.name;
    m.memberId = member.id;
    m.groupId = member.groupId;
    await AppUtils.navigateTo(
      context,
      MemberTransactionsList(
        _group,
        groupMemberDetails: m,
        trxPeriodDt: DateTime.now(),
      ),
    );
  }

  void editMember(GroupMember member) async {
    await AppUtils.navigateTo(
      context,
      MemberAddPage(
        _group,
        groupMember: member,
        key: ValueKey(member.id),
      ),
    );
    await getMembers();
  }

  Future<void> deleteMember(GroupMember member) async {
    try {
      var rows = await groupDao.deleteGroupMember(member);
      AppUtils.toast(context, "Deleted member");
      getMembers();
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocal.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(local.abMemberList),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ct) => MemberAddPage(_group),
            ),
          );
          await getMembers();
        },
        label: Text(local.bAddMember),
        icon: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await getMembers();
        },
        child: members.isEmpty
            ? Center(
                child: Text(local.mAddMemberMsg),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 300.0),
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
                              editMember(member);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_red_eye_outlined),
                            onPressed: () async {
                              handleShowTransactionListClick(member);
                            },
                          ),
                          CustomDeleteIcon<GroupMember>(
                            item: member,
                            content: Text("Member: ${member.name}"),
                            onAccept: (m) {
                              deleteMember(m);
                            },
                          ),
                        ],
                      ),
                      onTap: () async {
                        editMember(member);
                      },
                    ),
                  );
                },
                itemCount: members.length,
              ),
      ),
    );
  }
}
