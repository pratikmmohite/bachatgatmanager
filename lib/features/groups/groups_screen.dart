import 'package:flutter/material.dart';

import 'pages/group_add_page.dart';
import 'pages/groups_list_page.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final groupKey = GlobalKey<GroupsListPageState>();

  Future<void> refreshGroupList() async {
    await groupKey.currentState?.getGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saving Groups"),
      ),
      body: GroupsListPage(
        key: groupKey,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ct) => const GroupAddPage(),
            ),
          );
          await refreshGroupList();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
