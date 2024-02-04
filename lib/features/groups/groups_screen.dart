import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/features/groups/pages/save_data/import_export_page.dart';
import 'package:flutter/material.dart';

import '../../locals/app_local_delegate.dart';
import 'pages/group/group_add_page.dart';
import 'pages/group/groups_list_page.dart';

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
        title: Text(AppLocal.of(context).appTitle),
        actions: [
          ValueListenableBuilder(
            valueListenable: AppLocal.l(),
            builder: (context, local, child) {
              String changeTo = local.languageCode == "en" ? "mr" : "en";
              return TextButton(
                onPressed: () {
                  AppLocal.c(changeTo);
                },
                child: Text(changeTo),
              );
            },
            child: TextButton(
              onPressed: () {
                AppLocal.c("en");
              },
              child: const Text("en"),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.import_export),
            onPressed: () {
              AppUtils.navigateTo(context, const ImportExportPage());
            },
          )
        ],
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
