import 'package:flutter/material.dart';

import 'pages/group_add_page.dart';
import 'pages/groups_list_page.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saving Groups"),
      ),
      body: const GroupsListPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (ct) => const GroupAddPage(),),);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
